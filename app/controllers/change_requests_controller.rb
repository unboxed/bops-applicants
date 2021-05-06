class ChangeRequestsController < ApplicationController
  before_action :set_change_requests, only: %i[index show edit update]
  before_action :set_planning_application, only: %i[index show edit update]
  before_action :set_change_request, only: %i[show edit update]

  def index; end

  def show; end

  def edit
    @errors = []
  end

  def update
    if params["decision_change_request"]["approved"] == "no" && params["decision_change_request"]["rejection_reason"].blank?
      flash[:error] = "Please fill in the reason for disagreeing with the suggested change."
      render :edit
    elsif params["decision_change_request"]["approved"] == "yes"
      send_approved_description("southwark", params[:planning_application_id], params[:id], params[:change_access_id])
    elsif params["decision_change_request"]["approved"] == "no"
      send_rejected_description("southwark", params[:planning_application_id], params[:id], params[:change_access_id], params["decision_change_request"]["rejection_reason"])
    end
  end

private

  def set_change_request
    @change_request = @change_requests["data"].select { |obj| obj["id"] == params["id"].to_i }.first
  end

  def set_change_requests
    @change_requests = change_requests("southwark", params[:planning_application_id], params[:change_access_id])
  end

  def set_planning_application
    @planning_application = planning_application("southwark", params[:planning_application_id])
  end

  def get_request_successful?(request)
    if request.success?
      JSON.parse(request.body)
    else
      render plain: "Forbidden", status: 401
    end
  end

  def update_request_successful?(request)
    if request.success?
      flash[:notice] = "Change request successfully updated."
      redirect_to change_requests_path(
        change_access_id: params[:change_access_id],
        id: params[:id],
        planning_application_id: params[:planning_application_id],
      )
    else
      render plain: "Forbidden", status: 401
    end
  end

  def change_requests(subdomain, planning_application_id, change_request_id)
    request = HTTParty.get(
      "http://#{subdomain}.lvh.me:3000/api/v1/planning_applications/#{planning_application_id}/change_requests?change_access_id=#{change_request_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
    )
    get_request_successful?(request)
  end

  def planning_application(subdomain, planning_application_id)
    request = HTTParty.get(
      "http://#{subdomain}.lvh.me:3000/api/v1/planning_applications/#{planning_application_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
    )
    get_request_successful?(request)
  end

  def send_approved_description(subdomain, planning_application_id, description_change_request_id, change_access_id)
    request = HTTParty.patch(
      "http://#{subdomain}.lvh.me:3000/api/v1/planning_applications/#{planning_application_id}/description_change_requests/#{description_change_request_id}?change_access_id=#{change_access_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
      body: {
        "data": {
          "approved": true,
        },
      },
    )
    update_request_successful?(request)
  end

  def send_rejected_description(subdomain, planning_application_id, description_change_request_id, change_access_id, rejection_reason)
    request = HTTParty.patch(
      "http://#{subdomain}.lvh.me:3000/api/v1/planning_applications/#{planning_application_id}/description_change_requests/#{description_change_request_id}?change_access_id=#{change_access_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
      body: {
        "data": {
          "approved": false,
          "rejection_reason": rejection_reason.to_s,
        },
      },
    )
    update_request_successful?(request)
  end
end
