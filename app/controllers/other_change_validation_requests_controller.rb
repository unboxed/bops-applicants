class OtherChangeValidationRequestsController < ChangeRequestsController
  before_action :set_change_requests, only: %i[show edit update]
  before_action :set_planning_application, only: %i[show edit update]
  before_action :set_change_request, only: %i[show edit update]

  def show; end

  def edit; end

  def update
    if params["other_change_validation_request"]["response"].blank?
      flash[:error] = "Please enter your response to the planning officer's question."
      render :edit
    else
      send_response(current_local_authority, params[:planning_application_id], params[:id], params[:change_access_id], params[:other_change_validation_request][:response])
    end
  end

private

  def set_change_request
    @change_request = @change_requests["data"]["other_change_validation_requests"].select { |obj| obj["id"] == params["id"].to_i }.first
  end

  def set_planning_application
    @planning_application = planning_application(current_local_authority, params[:planning_application_id])
  end

  def update_request_successful?(request)
    if request.success?
      flash[:notice] = "Validation request successfully updated."
      redirect_to change_requests_path(
        change_access_id: params[:change_access_id],
        id: params[:id],
        planning_application_id: params[:planning_application_id],
      )
    else
      render plain: "Forbidden", status: 401
    end
  end

  def send_response(subdomain, planning_application_id, other_change_request_id, change_access_id, response)
    request = HTTParty.patch(
      "#{ENV['PROTOCOL']}://#{api_base(subdomain)}/planning_applications/#{planning_application_id}/other_change_validation_requests/#{other_change_request_id}?change_access_id=#{change_access_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
      body: {
        "data": {
          "response": response,
        },
      },
    )
    update_request_successful?(request)
  end
end
