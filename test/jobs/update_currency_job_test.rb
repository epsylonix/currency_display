require 'test_helper'

class UpdateCurrencyJobTest < ActiveJob::TestCase
  test "should fetch data from source and save it in the DB if it has changed" do
    val_was = @curr.val
    perform_enqueued_jobs do
      UpdateCurrencyJob.perform_later(@curr)
    end
    assert_performed_jobs 1
    @curr.reload
    assert_not_equal val_was, @curr.val
  end
end
