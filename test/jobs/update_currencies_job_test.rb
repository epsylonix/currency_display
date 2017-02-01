require 'test_helper'

class UpdateCurrenciesJobTest < ActiveJob::TestCase
  test "should enque update jobs for all currencies" do
    perform_enqueued_jobs do
      UpdateCurrenciesJob.perform_later
    end
    assert_performed_jobs 2
  end

end
