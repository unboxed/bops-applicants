# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

task(:"spec:prepare").clear.enhance(%i[dartsass:build javascript:build])
task(:default).clear.enhance(%i[bundle_audit brakeman rubocop spec])
