class DocumentChangeRequestsController < ValidationRequestsController
  before_action :set_change_requests, only: %i[show edit update]
  before_action :set_planning_application, only: %i[show edit update]
  before_action :set_change_request, only: %i[show edit update]

  def show; end

  def edit; end

  def update
    send_file(current_local_authority, params[:planning_application_id], params[:id], params[:change_access_id])
  end

private

  def send_file(subdomain, planning_application_id, document_change_request_id, change_access_id)
    request = HTTParty.patch(
      "#{ENV['PROTOCOL']}://#{api_base(subdomain)}/planning_applications/#{planning_application_id}/document_change_requests/#{document_change_request_id}?change_access_id=#{change_access_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
      body: {
        "new_file": params[:document_change_request][:file],
      },
    )
    update_request_successful?(request)
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
      render plain: "Forbidden", status: 401
    end
  end

  def set_change_request
    @change_request = @change_requests["data"]["document_change_requests"].select { |obj| obj["id"] == params["id"].to_i }.first
  end
end
