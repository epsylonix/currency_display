require 'test_helper'

class CurrenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @curr = Currency.find(1)
  end

# ============================================================
#  index
# ============================================================
  test "should get index" do
    get currencies_path
    assert_response :success
  end

  test "should display currencies at index" do
    get currencies_path
    assert_select '.currencies .currency', 1 
    
    tmp_curr = Currency.new(
      val: 1,
      code: 'xxx',
      forced_val: '1',
      forced_till: format_time(Time.zone.now),
      forced: false
    )
    tmp_curr.save
    
    get currencies_path
    assert_select '.currencies .currency', 2 
  end
  
  test "should display a page even when there are no currencies" do
    Currency.where(code:'usd').destroy_all
    get currencies_path
    assert_response :success
    assert_select '.currencies .currency', false
  end
  
  test "should display a normal currency value when forced==false" do
    get currencies_path
    assert_select '#usd', /100[\.\,]15/ 
  end

  test "should display the forced value when forced==true" do
    @curr.forced = true
    @curr.save!
    get currencies_path
    assert_select '#usd', /5[\.\,]0/ 
  end
  
# ============================================================
#  edit
# ============================================================
  test "should get a properly formed edit page at edit" do
    get edit_currency_path
    assert_response :success

    assert_select '.currency-form .text-input', 2
    assert_select '.currency-form input[type="checkbox"]', 1
    assert_select '.currency-form input[type="submit"]', 1
    assert_select '.currency-form .button-group a', 1
  end

  test "should fill the edit page with current currency values" do
    @curr.forced = true
    @curr.save!
    get edit_currency_path
    assert_select '#currency_forced_val:match("value",?)', /5[\.\,]00/ 
    assert_select '#currency_forced_till' do |input|
      assert_equal @curr.forced_till.to_s, Time.zone.parse(input.attr 'value' ).to_s
      # doesn't work without converting to string:
      # > No visible difference in the ActiveSupport::TimeWithZone#inspect output...
    end
    assert_select '#currency_forced[checked=checked]'
  end

  test "the edit page should handle wrong currency code with a 404 error" do
    Currency.where(code:'usd').destroy_all
    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_currency_path
    end
  end

  test "the home button should lead to the index page" do
    get edit_currency_path
    assert_select '.return-button[href=?]', currencies_path
  end
# ============================================================
#  update
# ============================================================

  test "should save values entered correctly and respond with a redirect when forced==false" do
    patch update_currency_path, 
      params: { 
        currency:{
          forced_val: '758,78',
          forced_till: format_time(Time.zone.now + 5.days),
          forced: '0'
        }
      }
    follow_redirect!  
    assert_response :success
    
    @curr.reload

    assert_select '.alert.alert-warning'
    assert_select '.alert.alert-success', false
    assert_select '.alert.alert-danger', false
    assert_select '#currency_forced_val:match("value",?)', /758[\.\,]78/ 
    assert_select '#currency_forced_till' do |input|
      assert_equal @curr.forced_till.to_s, Time.zone.parse(input.attr 'value' ).to_s
      # doesn't work without converting to string:
      # > No visible difference in the ActiveSupport::TimeWithZone#inspect output...
    end
    assert_select '#currency_forced[checked=checked]', false
  end

  test "should display a success message when forced==1" do
    patch update_currency_path, 
      params: { 
        currency:{
          forced_val: '758,78',
          forced_till: format_time(Time.zone.now + 5.days),
          forced: '1'
        }
      }
    follow_redirect!
    assert_response :success
    assert_select '.alert.alert-success'
    assert_select '.alert.alert-warning', false
    assert_select '.alert.alert-danger', false
    assert_select '#currency_forced[checked=checked]'
  end

  test "should display error messages when form contains errors" do
    patch update_currency_path, 
      params: { 
        currency:{
          forced_val: 'a758,78',
          forced_till: 'dasdasdas',
          forced: '0'
        }
      }
    assert_response :success
    assert_select '.alert.alert-danger', 2
    assert_select '.alert.alert-warning', false
    assert_select '.alert.alert-success', false
  end

  test "should rerender a user's input when the form contains errors" do
    patch update_currency_path, 
      params: { 
        currency:{
          forced_val: 'a758,78',
          forced_till: 'dasdasdas',
          forced: '0'
        }
      }
    assert_response :success   
    assert_select '.field_with_errors #currency_forced_val:match("value",?)', /a758[\.\,]78/ 
    assert_select '.field_with_errors #currency_forced_till:match("value",?)', /dasdasdas/
  end

  test "the update page should handle a wrong currency code with a 404 error" do
    Currency.where(code:'usd').destroy_all
    assert_raises(ActiveRecord::RecordNotFound) do
      patch update_currency_path, 
        params: { 
          currency:{
            forced_val: '758,78',
            forced_till: format_time(Time.zone.now + 5.days),
            forced: '0'
          }
        }
    end
  end
end
