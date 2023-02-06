# frozen_string_literal: true

RSpec.configure do |config|
  helpers = Module.new do
    def stub_get_replacement_document_validation_request(id:, planning_id:, change_access_id:, response_body:, status:)
      stub_request(
        :get,
        "#{ApiSpecHelper::API_BASE_URL}/#{planning_id}/replacement_document_validation_requests/#{id}?change_access_id=#{change_access_id}",
      )
      .with(
        headers:,
      )
      .to_return(
        body: JSON.generate(response_body),
        status:,
      )
    end

    def stub_patch_replacement_document_validation_request(id:, planning_id:, change_access_id:, status:)
      stub_request(
        :patch,
        "#{ApiSpecHelper::API_BASE_URL}/#{planning_id}/replacement_document_validation_requests/#{id}?change_access_id=#{change_access_id}",
      )
      .to_return(
        body: "",
        status:,
      )
    end
  end

  config.include helpers, type: :system
end
