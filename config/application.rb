# frozen_string_literal: true

require_relative "boot"
require_relative "../lib/quiet_logger"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BopsApplicants
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.action_controller.forgery_protection_origin_check = false

    # Don't log certain requests that spam the log files
    config.middleware.insert_before Rails::Rack::Logger, QuietLogger, paths: ["/healthcheck"]

    config.os_vector_tiles_api_key = ENV["OS_VECTOR_TILES_API_KEY"]
    config.api_host = ENV.fetch("API_HOST", "bops-care.link")
    config.api_protocol = ENV["PROTOCOL"]
    config.api_bearer = ENV["API_BEARER"]
  end
end
