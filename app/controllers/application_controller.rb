# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_local_authority

  before_action :set_current_local_authority
  before_action :set_header_link

  include Api::ErrorHandler

  def current_local_authority
    logger.info("\n\n\n***** Current local authority request subdomains first: #{request.subdomains.first} *****\n\n\n")
    request.subdomains.first
  end

  private

  def set_current_local_authority
    Current.local_authority = current_local_authority
  end

  def set_header_link
    @header_link = validation_requests_path(planning_application_id: params["planning_application_id"], change_access_id: params["change_access_id"])
  end
end
