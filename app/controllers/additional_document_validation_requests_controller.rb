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
      if @additional_document_validation_request.update
        flash[:notice] = t("shared.response_updated.success")
        format.html { validation_requests_redirect_url }
      else
        flash[:error] = error_message(@additional_document_validation_request)
        format.html { render :edit }
      end
    end
  end

  private

  def additional_document_validation_request_params
    params.require(:additional_document_validation_request).permit(files: [])
  end
end
