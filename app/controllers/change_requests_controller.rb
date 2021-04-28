class ChangeRequestsController < ApplicationController
  def index
    byebug
    @planning_application = planning_application("southwark", 28)
    # @planning_application = planning_application("southwark", params[:planning_application_id])
    # @change_requests = change_requests("southwark", params[:planning_application_id], params[:change_access_id])
    @change_requests = change_requests("southwark", 28, "f3778f8a79787e1b307f4e81bc9ff8")
  end

private

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
