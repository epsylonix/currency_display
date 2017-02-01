require 'net/http'

class CurrenciesController < ApplicationController
  around_action :use_users_timezone
  def index
    @any_update_failed = Currency.where(update_failed: true, forced: false).any?
    @currencies = Currency.all
    @currencies = [] if !@currencies 
  end

  def edit
    @curr = usd_or_param params
    @code = params_code params
  end

  def update
    # edit selected currency or usd if none selected
    @curr = usd_or_param params
    @curr.assign_attributes(curr_params)
    if @curr.valid?
      if !@curr.save
        flash.now[:danger] = 'Please try again later. If the problem persists please contact support.' 
      else
        # assign a new job
        if @curr.forced
          UnforceCurrencyJob.set(wait_until: @curr.forced_till).perform_later(@curr)
          flash[:success] = 'The currency value is forced.'
        else 
          flash[:warning] = 'Forced value is saved (enable to apply).'
        end
        # redirect to /admin if it was used to open edit page (no :code means usd is being edited)
        # else redirect to /admin/:code
        redirect_to edit_currency_path(params_code params)
      end
    else
      render 'edit'
    end
    
  end

  private 
  def curr_params
    params.require(:currency).permit(:code, :forced_val, :forced_till, :forced)
  end

  # returns :code from the request if there is one
  def params_code params
    params[:code] ? params[:code] : ''
  end

  # returns usd currency or currency with code from the request 
  def usd_or_param( params )
    curr_code = params[:code] ? params[:code] : 'usd'
    curr = Currency.where(code: curr_code).first  # doesn't allow SQL Injection
    raise ActiveRecord::RecordNotFound if !curr
    
    curr
  end

  # treat user's input with an appropriate tinezone setting
  def use_users_timezone
    timezone = Time.find_zone(cookies[:timezone]) or Time.zone
    Time.use_zone(timezone) { yield }
  end

end
