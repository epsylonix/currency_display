require 'test_helper'

class RoutingTest < ActionDispatch::IntegrationTest
  # ============================================================
  #  routing
  # ============================================================
    test "the index page should be routed to root" do
      assert_equal '/', currencies_path
    end

    test "the edit and the update pages should be routed to /admin" do
      assert_equal '/admin', edit_currency_path
      assert_equal '/admin', update_currency_path
    end
end
  