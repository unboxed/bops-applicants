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
gem "jbuilder", "~> 2.7"
gem "jsbundling-rails"
gem "puma", ">= 5.3.1"
gem "rails", "~> 7.0"
gem "rails_autolink"
gem "sprockets-rails"
gem "turbolinks", "~> 5"
gem "view_component"

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "capybara"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rspec-rails", "~> 5.0.0"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "webdrivers"
end

group :development do
  gem "foreman"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
end

group :test do
  gem "webmock", "~> 3.12", ">= 3.12.2"
end
