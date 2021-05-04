class ChangeRequestsController < ApplicationController
  before_action :set_change_requests, only: %i[index show]
  before_action :set_planning_application, only: %i[index show]

  def index; end

  def show
    @change_request = @change_requests["data"].select { |obj| obj["id"] == params["id"].to_i }
  end

private

  def set_change_requests
    @change_requests = change_requests("southwark", params[:planning_application_id], params[:change_access_id])
  end

  def set_planning_application
    @planning_application = planning_application("southwark", params[:planning_application_id])
  end

  def change_requests(subdomain, planning_application_id, change_request_id)
    request = HTTParty.get(
      "http://#{subdomain}.lvh.me:3000/api/v1/planning_applications/#{planning_application_id}/change_requests?change_access_id=#{change_request_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
    )

    if request.success?
      JSON.parse(request.body)
    else
      render plain: "Forbidden", status: 401
    end
  end

  def planning_application(subdomain, planning_application_id)
    request = HTTParty.get(
      "http://#{subdomain}.lvh.me:3000/api/v1/planning_applications/#{planning_application_id}",
      headers: { "Authorization": "Bearer #{ENV['API_BEARER']}" },
    )

    if request.success?

      JSON.parse(request.body)
    else
      render plain: "Forbidden", status: 401
    end
  end
end
