require 'clockwork'
require_relative './config/boot'
require_relative './config/environment'

module Clockwork
  every(1.day, 'Update currencies\' every day' , :at => '00:00', :tz => Time.zone.name) do
    UpdateCurrenciesJob.perform_now
  end

  every(1.hour, 'Verify currencies\' didn\'t change during the day') do
    UpdateCurrenciesJob.perform_now
  end
end