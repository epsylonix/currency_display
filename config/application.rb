require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CurrDisplay
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Europe/Moscow'

    config.active_job.queue_adapter = :delayed_job

    config.action_cable.allowed_request_origins =  ['http://localhost:3000', 'http://127.0.0.1:3000']

    I18n.config.available_locales = :ru, :en
    config.i18n.default_locale = :ru

    config.after_initialize do
      begin
        Currency.all.each do |curr|
          UpdateCurrencyJob.perform_now curr
        end
      rescue ActiveRecord::StatementInvalid
        # otherwise it will fail to migrate db in the first run of db:migrate
      end
    end
  end
end
