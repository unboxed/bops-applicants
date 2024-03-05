# frozen_string_literal: true

module Apis
  module Bops
    class Client
      class << self
        # Planning application
        def get_planning_application(planning_application_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}"
          )
        end

        # Local authority
        def get_local_authority(local_authority_subdomain)
          request(
            http_method: :get,
            endpoint: "local_authorities/#{local_authority_subdomain}"
          )
        end

        def post_neighbour_response(planning_application_id, name:, response:, address:, email:, summary_tag:, files:, tags:)
          request(
            http_method: :post,
            endpoint: "planning_applications/#{planning_application_id}/neighbour_responses",
            params: {
              name:,
              response:,
              address:,
              email:,
              summary_tag:,
              files:,
              tags:
            },
            upload_file: true
          )
        end

        # Validation requests
        def get_validation_requests(planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/validation_requests?change_access_id=#{change_access_id}"
          )
        end

        # Description change validation requests
        def get_description_change_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/description_change_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_approved_description_change(id, planning_application_id, change_access_id)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/description_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: true
              }
            }.to_json
          )
        end

        def patch_rejected_description_change(id, planning_application_id, change_access_id, rejection_reason)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/description_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: false,
                rejection_reason:
              }
            }.to_json
          )
        end

        # Fee change validation requests
        def get_fee_change_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/fee_change_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_response_fee_change_request(id, planning_application_id, change_access_id, response, files)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/fee_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                response:,
                supporting_documents: files
              }
            },
            upload_file: true
          )
        end

        # Other change validation requests
        def get_other_change_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/other_change_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_response_other_change_request(id, planning_application_id, change_access_id, response)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/other_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                response:
              }
            }.to_json
          )
        end

        # Ownership certificate validation requests
        def get_ownership_certificate_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/ownership_certificate_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_approved_ownership_certificate(id, planning_application_id, change_access_id, params)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/ownership_certificate_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                params: params[:params],
                approved: true
              }
            }.to_json
          )
        end

        def patch_rejected_ownership_certificate(id, planning_application_id, change_access_id, rejection_reason)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/ownership_certificate_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: false,
                rejection_reason:
              }
            }.to_json
          )
        end

        # Pre commencement condition validation requests
        def get_pre_commencement_condition_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/pre_commencement_condition_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_approved_pre_commencement_condition_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/pre_commencement_condition_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: true
              }
            }.to_json
          )
        end

        def patch_rejected_pre_commencement_condition_validation_request(id, planning_application_id, change_access_id, rejection_reason)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/pre_commencement_condition_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: false,
                rejection_reason:
              }
            }.to_json
          )
        end

        # Heads of terms validation requests
        def get_heads_of_terms_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/heads_of_terms_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_approved_heads_of_terms_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/heads_of_terms_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: true
              }
            }.to_json
          )
        end

        def patch_rejected_heads_of_terms_validation_request(id, planning_application_id, change_access_id, rejection_reason)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/heads_of_terms_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: false,
                rejection_reason:
              }
            }.to_json
          )
        end

        # Red line boundary change validation requests
        def get_red_line_boundary_change_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/red_line_boundary_change_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_approved_red_line_boundary_change(id, planning_application_id, change_access_id)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/red_line_boundary_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: true
              }
            }.to_json
          )
        end

        def patch_rejected_red_line_boundary_change(id, planning_application_id, change_access_id, rejection_reason)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/red_line_boundary_change_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              data: {
                approved: false,
                rejection_reason:
              }
            }.to_json
          )
        end

        # Additional document validation requests
        def get_additional_document_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/additional_document_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_additional_documents(id, planning_application_id, change_access_id, files)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/additional_document_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              files:
            },
            upload_file: true
          )
        end

        # Replacement document validation requests
        def get_replacement_document_validation_request(id, planning_application_id, change_access_id)
          request(
            http_method: :get,
            endpoint: "planning_applications/#{planning_application_id}/replacement_document_validation_requests/#{id}?change_access_id=#{change_access_id}"
          )
        end

        def patch_replacement_document(id, planning_application_id, change_access_id, file)
          request(
            http_method: :patch,
            endpoint: "planning_applications/#{planning_application_id}/replacement_document_validation_requests/#{id}?change_access_id=#{change_access_id}",
            params: {
              file:
            },
            upload_file: true
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
