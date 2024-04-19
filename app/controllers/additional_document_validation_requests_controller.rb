# frozen_string_literal: true

class AdditionalDocumentValidationRequestsController < ValidationRequestsController
  before_action :set_validation_request

  rescue_from Request::RequestEntityTooLargeError do |error|
    @additional_document_validation_request.errors.add(:files, request_error_message(error))

    render :edit
  end

  def show
    respond_to do |format|
      if validation_request_is_closed? || validation_request_is_cancelled?
        format.html
      else
        format.html { render_not_found }
      end
    end
  end

  def edit
    respond_to do |format|
      if validation_request_is_open?
        @additional_document_validation_request = build_validation_request
        format.html
      else
        format.html { render_not_found }
      end
    end
  end

  def update
    @additional_document_validation_request = build_validation_request(additional_document_validation_request_params)

    respond_to do |format|
      format.html do
        if @additional_document_validation_request.update
          redirect_to validation_requests_path(
            planning_application_id: params[:planning_application_id],
            change_access_id: params[:change_access_id]
          ), notice: t("shared.response_updated.success")
        else
          render :edit
        end
      end
    end
  end

  private

  def additional_document_validation_request_params
    params.require(:additional_document_validation_request).permit(files: [])
  end
end
