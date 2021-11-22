class ReplacementDocumentValidationRequestsController < ValidationRequestsController
  before_action :set_validation_request

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
        @replacement_document_validation_request = build_validation_request
        format.html
      else
        format.html { render_not_found }
      end
    end
  end

  def update
    @replacement_document_validation_request = build_validation_request(replacement_document_validation_request_params)

    respond_to do |format|
      if @replacement_document_validation_request.update
        flash[:notice] = "Your response was updated successfully"
        format.html { validation_requests_redirect_url }
      else
        flash[:error] = error_message(@replacement_document_validation_request)
        format.html { render :edit }
      end
    end
  end

private

  def replacement_document_validation_request_params
    params.require(:replacement_document_validation_request).permit(:file)
  end
end
