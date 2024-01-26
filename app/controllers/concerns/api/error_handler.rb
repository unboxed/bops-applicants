# frozen_string_literal: true

module Api
  module ErrorHandler
    extend ActiveSupport::Concern
    include HttpStatusCodes

    included do
      rescue_from Request::BopsApiError, with: :format_error

      private

      def format_error(error)
        error_hash = JSON.parse(error.message)

        response = error_hash["response"]
        message = response["message"] || response
        status = error_hash["status"].to_s || API_ERROR.to_s
        http_method = error_hash["http_method"].to_s

        respond_to do |format|
          format.json do
            render json: {
              errors: [
                {
                  title: message,
                  status:
                }
              ]
            }, status:
          end

          format.html do
            if render_not_found?(status, http_method)
              render_not_found
            else
              flash[:alert] = "Oops. Your request failed with error status: #{status} and message: #{message}"

              validation_requests_redirect_url
            end
          end
        end
      end

      def render_not_found?(status, http_method)
        return true if status == NOT_FOUND.to_s

        http_method == "get" && (status == UNAUTHORIZED.to_s || status == FORBIDDEN.to_s)
      end

      def validation_requests_redirect_url
        redirect_to validation_requests_path(
          planning_application_id: params[:planning_application_id],
          change_access_id: params[:change_access_id]
        )
      end
    end
  end
end
