ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use! 

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.current_driver = Capybara.javascript_driver
# webrick server doesn't support websockets
Capybara.server = :puma
Capybara.server_port = 3000
Capybara.default_max_wait_time = 10

require 'simplecov'
SimpleCov.start


# utility functions
module Utils
  # format datetime in the form that is excepted by from validations 
  def format_time time
    time.strftime("%d.%m.%Y   %H:%M:%S")
  end
end

# Use webmock instead of http requests to a 3rd party API 
module MockHttp
  def setup
    # stub for USD (VAL_NM_RQ=R01235 in the request)
    # dates used in response_xml are not important
    # because USD_value method doesn't check them 
    # (look for explanation in method description) 
    response_xml = File.open("test/assets/cbr_usd_response.xml").read
    stub_request(:get, /.*www\.cbr\.ru[^V]*\VAL_NM_RQ\=R01235/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_xml, headers: {})
    super
  end
end

class ActiveSupport::TestCase
  include MockHttp
  include Utils
  # without this all jobs will run immediately:
  include ActiveJob::TestHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all  

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
  end
end

class ActiveJob::TestCase
  setup do
    @curr = Currency.find(1)
    @curr.forced = true
    @curr.save!
  end
end