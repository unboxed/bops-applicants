class DescriptionChangeValidationRequestsController < ValidationRequestsController
  before_action :set_validation_requests, only: %i[show edit update]
  before_action :set_planning_application, only: %i[show edit update]
  before_action :set_validation_request, only: %i[show edit update]

  def show; end

  def edit; end

  def update
    if params["description_change_validation_request"]["approved"] == "no" && params["description_change_validation_request"]["rejection_reason"].blank?
      flash[:error] = "Please fill in the reason for disagreeing with the suggested change."
      render :edit
    elsif params["description_change_validation_request"]["approved"] == "yes"
      send_approved_description(current_local_authority, params[:planning_application_id], params[:id], params[:change_access_id])
    elsif params["description_change_validation_request"]["approved"] == "no"
      send_rejected_description(current_local_authority, params[:planning_application_id], params[:id], params[:change_access_id], params["description_change_validation_request"]["rejection_reason"])
    end
  end

private

  def set_validation_request
    @validation_request = @validation_requests["data"]["description_change_validation_requests"].select { |obj| obj["id"] == params["id"].to_i }.first
  end

  def set_planning_application
    @planning_application = planning_application(current_local_authority, params[:planning_application_id])
  end

  def update_request_successful?(request)
    if request.success?
      flash[:notice] = "Change request successfully updated."
      redirect_to validation_requests_path(
        change_access_id: params[:change_access_id],
        id: params[:id],
        planning_application_id: params[:planning_application_id],
      )
    else
      render plain: "Forbidden", status: :unauthorized
    end
  end

  def send_approved_description(subdomain, planning_application_id, description_change_validation_request_id, change_access_id)
    request = HTTParty.patch(
      "#{ENV['PROTOCOL']}://#{api_base(subdomain)}/planning_applications/#{planning_application_id}/description_change_validation_requests/#{description_change_validation_request_id}?change_access_id=#{change_access_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
      body: {
        "data": {
          "approved": true,
        },
      },
    )
    update_request_successful?(request)
  end

  def send_rejected_description(subdomain, planning_application_id, description_change_validation_request_id, change_access_id, rejection_reason)
    request = HTTParty.patch(
      "#{ENV['PROTOCOL']}://#{api_base(subdomain)}/planning_applications/#{planning_application_id}/description_change_validation_requests/#{description_change_validation_request_id}?change_access_id=#{change_access_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
      body: {
        "data": {
          "approved": false,
          "rejection_reason": rejection_reason,
        },
      },
    )
    update_request_successful?(request)
  end
end
