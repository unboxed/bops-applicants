# frozen_string_literal: true

module Apis
  module Bops
    class Client
      class << self
        def get_validation_requests(planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "#{planning_application_id}/validation_requests?change_access_id=#{change_access_id}",
          )
        end

        def get_planning_application(planning_application_id)
          request(
            http_method: :get,
            endpoint: planning_application_id.to_s,
          )
        end

        def patch_approved_description_change(id, planning_application_id, change_access_id)
          request(
            http_method: :patch,
            endpoint: "#{planning_application_id}/description_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              "data": {
                "approved": true,
              },
            }.to_json,
          )
        end

        def patch_rejected_description_change(id, planning_application_id, change_access_id, rejection_reason)
          request(
            http_method: :patch,
            endpoint: "#{planning_application_id}/description_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              "data": {
                "approved": false,
                "rejection_reason": rejection_reason,
              },
            }.to_json,
          )
        end

        def patch_response_other_change_request(id, planning_application_id, change_access_id, response)
          request(
            http_method: :patch,
            endpoint: "#{planning_application_id}/other_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              "data": {
                "response": response,
              },
            }.to_json,
          )
        end

        def patch_approved_red_line_boundary_change(id, planning_application_id, change_access_id)
          request(
            http_method: :patch,
            endpoint: "#{planning_application_id}/red_line_boundary_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                "approved": true,
              },
            }.to_json,
          )
        end

        def patch_rejected_red_line_boundary_change(id, planning_application_id, change_access_id, rejection_reason)
          request(
            http_method: :patch,
            endpoint: "#{planning_application_id}/red_line_boundary_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              "data": {
                "approved": false,
                "rejection_reason": rejection_reason,
              },
            }.to_json,
          )
        end

        def patch_additional_document(id, planning_application_id, change_access_id, file)
          request(
            http_method: :patch,
            endpoint: "#{planning_application_id}/additional_document_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              "file": file,
            },
            upload_file: true,
          )
        end

        def patch_replacement_document(id, planning_application_id, change_access_id, file)
          request(
            http_method: :patch,
            endpoint: "#{planning_application_id}/replacement_document_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              "file": file,
            },
            upload_file: true,
          )
        end

      private

        def request(http_method:, endpoint:, params: {}, upload_file: false)
          Request.new(http_method, endpoint, params, upload_file).call
        end
      end
    end
  end
end
