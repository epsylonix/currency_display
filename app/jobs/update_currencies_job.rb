class UpdateCurrenciesJob < ApplicationJob
  queue_as :default

  def perform
      Currency.all.each do |curr|
        UpdateCurrencyJob.perform_later curr
      end
  end
end
