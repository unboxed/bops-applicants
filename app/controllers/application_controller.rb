# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_local_authority

  before_action :set_current_local_authority
  before_action :set_header_link

  include Api::ErrorHandler

  def current_local_authority
    request.subdomains.first
  end

  private

  def set_current_local_authority
    Current.local_authority = current_local_authority
  end

  def set_header_link
    @header_link = validation_requests_path(planning_application_id: params["planning_application_id"], change_access_id: params["change_access_id"])
  end

  def set_planning_application
    reference = params[:planning_application_reference] || params[:reference] || params[:planning_application_id]
    @planning_application = Bops::PlanningApplication.find(reference)
  end
end
