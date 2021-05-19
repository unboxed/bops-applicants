class ChangeRequestsController < ApplicationController
  before_action :set_change_requests, only: :index
  before_action :set_planning_application, only: :index

  def index; end

private

  def set_change_requests
    @change_requests = change_requests(current_local_authority, params[:planning_application_id], params[:change_access_id])
  end

  def set_planning_application
    @planning_application = planning_application(current_local_authority, params[:planning_application_id])
  end

  def get_request_successful?(request)
    if request.success?
      JSON.parse(request.body)
    else
      render plain: "Forbidden", status: 401
    end
  end

  def api_base(subdomain)
    "#{subdomain}.#{ENV['API_HOST'] || 'lvh.me:3000'}/api/v1"
  end

  def change_requests(subdomain, planning_application_id, change_request_id)
    request = HTTParty.get(
      "#{ENV['PROTOCOL']}://#{api_base(subdomain)}/planning_applications/#{planning_application_id}/change_requests?change_access_id=#{change_request_id}",
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
