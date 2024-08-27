# frozen_string_literal: true

source "https://rubygems.org"

# Load environment variables
gem "dotenv-rails", require: "dotenv/rails-now"

gem "appsignal"
gem "bootsnap", ">= 1.4.4", require: false
gem "dartsass-rails"
gem "faraday"
gem "govuk_design_system_formbuilder"
gem "httparty"
gem "jsbundling-rails"
gem "lograge", "~> 0.14.0"
gem "pg"
gem "puma", ">= 5.3.1"
gem "rails", "~> 7.2"
gem "rails_autolink"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbolinks", "~> 5"
gem "view_component"

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "capybara"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rspec-rails", "~> 6.0"
  gem "standard", "~> 1.31", require: false
  gem "standard-custom", require: false
  gem "standard-performance", require: false
  gem "standard-rails", require: false
  gem "selenium-webdriver"
end

group :development do
  gem "foreman"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
end

group :test do
  gem "webmock", "~> 3.12", ">= 3.12.2"
end
