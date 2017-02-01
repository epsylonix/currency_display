require 'test_helper'

class AppFlowTest < ActiveSupport::TestCase
  include Capybara::DSL

  test "forced value are updated in opened windows" do
    visit '/'
    assert page.has_selector? "#usd", text: /100[\.\,]15/
    
    admin_window = open_new_window
    within_window admin_window do
      visit '/admin'
      assert page.has_no_selector?('.alert-success')

      assert page.has_field?('currency_forced_val')
      fill_in 'currency_forced_val', with: '1234,56'
      assert page.has_no_selector?('.error')
      
      assert page.has_field?('currency_forced_till')
      fill_in 'currency_forced_till', with: (Time.zone.tomorrow.noon).strftime("%d.%m.%Y   %H:%M:%S")
      assert page.has_no_selector?('.error')

      find('#currency_forced_label').click
      assert page.has_selector?('#currency_forced:checked', visible: false)

      find('input[type="submit"]').click
      assert page.has_selector?('.alert-success')
      assert page.has_selector?('#currency_forced[checked=checked]', visible: false)
    end
    assert page.has_selector? "#usd", text: /1[\s]?234[\.\,]56/
  end
end