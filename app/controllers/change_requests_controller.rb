class ChangeRequestsController < ApplicationController
  # southwark.bop-applicants.services/change_requests?planning_application_id=1&change_access_id=1
  def index
    @change_requests = BopsApi.change_requests(subdomain, params[:planning_application_id], params[:change_access_id])
  end
end
