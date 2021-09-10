class ValidationRequestsController < ApplicationController
  before_action :set_validation_requests, only: :index
  before_action :set_planning_application, only: :index

  def index; end

private

  def set_validation_requests
    @validation_requests = validation_requests(current_local_authority, params[:planning_application_id], params[:change_access_id])
  end

  def set_planning_application
    @planning_application = planning_application(current_local_authority, params[:planning_application_id])
  end

  def get_request_successful?(request)
    if request.success?
      JSON.parse(request.body)
    else
      render plain: "Forbidden", status: :unauthorized
    end
  end

  def api_base(subdomain)
    "#{subdomain}.#{ENV['API_HOST'] || 'local.abscond.org'}/api/v1"
  end

  def validation_requests(subdomain, planning_application_id, change_request_id)
    request = HTTParty.get(
      "#{ENV['PROTOCOL']}://#{api_base(subdomain)}/planning_applications/#{planning_application_id}/validation_requests?change_access_id=#{change_request_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
    )
    get_request_successful?(request)
  end

  def planning_application(subdomain, planning_application_id)
    request = HTTParty.get(
      "#{ENV['PROTOCOL']}://#{api_base(subdomain)}/planning_applications/#{planning_application_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
    )
    get_request_successful?(request)
  end
end
