require 'test_helper'

class JobQueueTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  
  setup do
    @curr = Currency.find(1)
    @future_date = Date.tomorrow.noon
    @past_date = Date.yesterday.noon
  end

  # ============================================================
  #  jobs
  # ============================================================

    test "the update page should enque UnforceCurrencyJob when forced==true and forced_till is in the future" do
      assert_enqueued_with(job: UnforceCurrencyJob, at:@future_date) do
        patch '/admin', 
          params: { 
            currency:{
              forced_val: '1',
              forced_till: format_time(@future_date),
              forced: '1'
            }
          }
        follow_redirect!
        assert_response :success
      end
      assert_enqueued_jobs 1
    end

    test "the update page shouldn't enque jobs when forced==false" do
      assert_no_enqueued_jobs do
        patch '/admin', 
          params: { 
            currency:{
              forced_val: '1',
              forced_till: format_time(@future_date),
              forced: '0'
            }
          }
        follow_redirect!
        assert_response :success
      end
    end

    test "the update page shouldn't enque jobs when forced_till time has already passed" do
      assert_no_enqueued_jobs do
        patch '/admin', 
          params: { 
            currency:{
              forced_val: '1',
              forced_till: format_time(@past_date),
              forced: '1'
            }
          }
        assert_response :success
      end
    end

    test "the update page should enque another job when a new forced value is posted " do
      assert_enqueued_with(job: UnforceCurrencyJob, at:@future_date) do
        patch '/admin', 
          params: { 
            currency:{
              forced_val: '1',
              forced_till: format_time(@future_date),
              forced: '1'
            }
          }
        follow_redirect!
        assert_response :success
      end
      assert_enqueued_jobs 1
      
      assert_enqueued_with(job: UnforceCurrencyJob, at: @future_date + 1.hour) do
        patch '/admin', 
          params: { 
            currency:{
              forced_val: '1',
              forced_till: format_time(@future_date + 1.hour),
              forced: '1'
            }
          }
      end
      follow_redirect!
      assert_response :success
      assert_enqueued_jobs 2
    end
end