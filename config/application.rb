require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Striped
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    # Turn off Coffeescript
    config.generators.javascripts = false
    config.autoload_paths << Rails.root.join('app/gateways')
    
    config.action_mailer.default_url_options = { host: 'rubyplus.com' }
  end
end

# Customer actor
require_relative '../app/actors/customer/use_cases/subscribe_to_a_plan'
require_relative '../app/actors/customer/use_cases/guest_checkout'
require_relative '../app/actors/customer/use_cases/one_click_checkout'
require_relative '../app/actors/customer/use_cases/update_credit_card_expiration_date'
require_relative '../app/actors/customer/use_cases/add_new_credit_card'

# Stripe System actor
require_relative '../app/actors/stripe/use_cases/process_subscription_payment_failure'