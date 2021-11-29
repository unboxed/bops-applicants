class ValidationRequestsController < ApplicationController
  include Api::ErrorHandler

  before_action :set_planning_application, :set_validation_requests, only: :index

  def index
    respond_to do |format|
      format.html
    end
  end

private

  def set_validation_requests
    @validation_requests = Bops::ValidationRequest.find_all(params[:planning_application_id], params[:change_access_id])
  end

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end

  def set_validation_request
    @validation_request = validation_request_model_klass.find(
      params[:id], params[:planning_application_id], params[:change_access_id]
    )
  end

  def build_validation_request(attributes = {})
    validation_request_model_klass.new(attributes).tap do |attribute|
      attribute.id = params[:id]
      attribute.planning_application_id = params[:planning_application_id]
      attribute.change_access_id = params[:change_access_id]
    end
  end

  def validation_requests_redirect_url
    redirect_to validation_requests_path(
      planning_application_id: params[:planning_application_id],
      change_access_id: params[:change_access_id],
    )
  end

  def render_not_found
    render plain: "Not Found", status: :not_found
  end

  def validation_request_is_closed?
    state == "closed"
  end

  def validation_request_is_open?
    state == "open"
  end

  def validation_request_is_cancelled?
    state == "cancelled"
  end

  def state
    @state ||= @validation_request["state"]
  end

  def error_message(validation_request)
    errors = validation_request.errors
    errors.any? ? errors.full_messages.to_sentence : "Oops something went wrong. Please contact support."
  end

  def validation_request_model_klass
    "Bops::#{controller_name.classify}".constantize
  end
end
