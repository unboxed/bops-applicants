source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.6"

gem "dotenv-rails", require: "dotenv/rails-now"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.3.2"
# Use Puma as the app server
gem "puma", ">= 5.3.1"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem "aws-sdk-codedeploy", require: false
gem "aws-sdk-s3", require: false
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "govuk_design_system_formbuilder"
gem "httparty"

group :test do
  gem "webmock", "~> 3.12", ">= 3.12.2"
end

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "capybara"
  gem "rspec-rails", "~> 5.0.0"
  gem "rubocop", require: false
  gem "rubocop-govuk", require: false
  gem "selenium-webdriver"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
