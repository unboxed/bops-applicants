# frozen_string_literal: true

require "spec_helper"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.file_fixture_path = "#{::Rails.root}/spec/fixtures"

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include ApiSpecHelper
  config.include SystemSpecHelpers

  config.before do |example|
    @default_local_authority = "default"
    case example.metadata[:type]
    when :request
      host! "default.example.com"
    when :system
      Capybara.app_host = "http://default.example.com"
    end
  end
end
