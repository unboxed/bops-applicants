# frozen_string_literal: true

RSpec.configure do |config|
  config.before :suite do
    javascript_path = Rails.root.join("app/assets/builds/application.js")
    stylesheet_path = Rails.root.join("app/assets/builds/application.css")

    unless File.exist?(javascript_path) && File.exist?(stylesheet_path)
      raise "Please compile assets before running specs individually"
    end
  end
end
