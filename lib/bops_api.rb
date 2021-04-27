class BopsApi
  def change_requests(subdomain, planning_application_id, change_request_id)
    response = HTTParty.get("http://#{subdomain}.lvh.me:3000/api/v1/planning_applications/#{planning_application_id}/change_requests?change_access_id=#{planning_application_id}")
  end
end

# Tests:
# expect(HTTParty).to recieve("southwark.bop-applicants.services/change_requests?planning_application_id=1&change_access_id=1").and_return("{"data": etc}")