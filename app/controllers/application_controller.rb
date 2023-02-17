# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_local_authority

  before_action :set_current_local_authority

  include Api::ErrorHandler

  def current_local_authority
    request.subdomains.first
  end

  private

  def set_current_local_authority
    Current.local_authority = current_local_authority
  end
end
