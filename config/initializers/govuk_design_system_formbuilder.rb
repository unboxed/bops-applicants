# frozen_string_literal: true

require "govuk_design_system_formbuilder"

GOVUKDesignSystemFormBuilder.configure do |conf|
  Rails.application.config.to_prepare do
    ActionView::Base.default_form_builder = GOVUKDesignSystemFormBuilder::FormBuilder
  end
end
