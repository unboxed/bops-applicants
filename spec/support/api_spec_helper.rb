# frozen_string_literal: true

module ApiSpecHelper
  API_BASE_URL = "https://default.bops.test/api/v1/planning_applications"

  def headers
    {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
      "Authorization" => "Bearer 123",
      "Content-Type" => "application/json",
      "User-Agent" => "Faraday v2.3.0"
    }
  end

  def stub_successful_get_planning_application
    stub_request(:get, "https://default.bops.test/api/v1/planning_applications/28")
      .with(headers:)
      .to_return(status: 200, body: file_fixture("test_planning_application.json").read, headers: {})
  end

  def stub_successful_get_private_planning_application
    stub_request(:get, "https://default.bops.test/api/v1/planning_applications/29")
      .with(headers:)
      .to_return(status: 200, body: file_fixture("test_private_planning_application.json").read, headers: {})
  end

  def stub_unsuccessful_get_planning_application
    stub_request(:get, "https://default.bops.test/api/v1/planning_applications/100")
      .with(headers:)
      .to_return(status: 404, body: '{"message": "Not found"}', headers: {})
  end

  def stub_successful_get_local_authority
    stub_request(:get, "https://default.bops.test/api/v1/local_authorities/default")
      .with(headers:)
      .to_return(status: 200, body: '{"email_address": "planning@southwark.com"}', headers: {})
  end

  def stub_successful_get_change_requests
    stub_request(:get, "https://default.bops.test/api/v1/planning_applications/28/validation_requests?change_access_id=345443543")
      .with(headers:)
      .to_return(status: 200, body: file_fixture("test_change_request_index.json").read, headers: {})
  end

  def stub_rejected_patch_with_reason
    stub_request(:get, "https://default.bops.test/api/v1/planning_applications/28/validation_requests?change_access_id=345443543")
      .with(headers:)
      .to_return(status: 200, body: file_fixture("rejected_request.json").read, headers: {})
  end

  def stub_cancelled_change_requests
    stub_request(:get, "https://default.bops.test/api/v1/planning_applications/28/validation_requests?change_access_id=345443543")
      .with(headers:)
      .to_return(status: 200, body: file_fixture("cancelled_validation_requests.json").read, headers: {})
  end

  def stub_successful_post_neighbour_response(planning_application_id:, name:, email:, address:, response:, summary_tag:, files:, tags:)
    tag_response = tags.map do |tag|
      "&tags%5B%5D=#{tag}"
    end.join
    stub_request(:post, "https://default.bops.test/api/v1/planning_applications/#{planning_application_id}/neighbour_responses")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer 123",
          "User-Agent" => "Ruby"
        },
        body: "name=#{ERB::Util.url_encode(name)}&response=#{ERB::Util.url_encode(response)}&address=#{ERB::Util.url_encode(address)}&email=#{ERB::Util.url_encode(email)}&summary_tag=#{ERB::Util.url_encode(summary_tag)}&files%5B%5D=#{ERB::Util.url_encode(files)}#{tag_response}"
      )
      .to_return(status: 200, headers: {}, body: "{}")
  end

  def stub_get_planning_application(file_fixture, additional_fields: nil)
    response_body = file_fixture(file_fixture).read

    if additional_fields
      parsed_body = JSON.parse(response_body)
      parsed_body.merge!(additional_fields)
      response_body = parsed_body.to_json
    end

    stub_request(:get, "https://default.bops.test/api/v1/planning_applications/28")
      .with(headers:)
      .to_return(status: 200, body: response_body, headers: {})
  end
end
