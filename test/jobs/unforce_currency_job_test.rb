require 'test_helper'

class UnforceCurrencyJobTest < ActiveJob::TestCase
  test "should change the forced value to false after a successful execution" do
    perform_enqueued_jobs do
      UnforceCurrencyJob.perform_later(@curr)
    end
    assert_performed_jobs 1
    @curr.reload
    assert_equal false, @curr.forced
  end

  test "shouldn't do anything if curr.forced_till changed" do
    perform_enqueued_jobs do
      UnforceCurrencyJob.perform_later(@curr, Date.tomorrow.midnight.to_s)
    end
    assert_performed_jobs 1
    @curr.reload
    assert_equal true, @curr.forced
  end

end
