class UnforceCurrencyJob < ApplicationJob
  queue_as :default

  def perform(curr, test_wait = nil)
    # it's hard to test delayed job execution, so here is a hack
    scheduled_at = DateTime.parse(test_wait) if Rails.env.test? and test_wait

    # perform only if forced==true and forced_till didn't change 
    # or if called with perform now and there is no scheduled_at at all
    if curr.forced and (!scheduled_at or Time.at(scheduled_at).to_datetime == curr.forced_till)
      curr.forced = false
      curr.save
    end
  end

end
