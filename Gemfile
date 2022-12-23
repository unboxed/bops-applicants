source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

gem "dotenv-rails", require: "dotenv/rails-now"

gem "bootsnap", ">= 1.4.4", require: false
gem "faraday"
gem "govuk_design_system_formbuilder"
gem "httparty"
gem "jbuilder", "~> 2.7"
gem "puma", ">= 5.3.1"
gem "rails", "~> 6.1"
gem "rails_autolink"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "view_component"
gem "webpacker", "~> 5.0"

group :test do
  gem "webmock", "~> 3.12", ">= 3.12.2"
end

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "capybara"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rspec-rails", "~> 5.0.0"
  gem "rubocop", require: false
  gem "rubocop-govuk", require: false
  gem "webdrivers"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
