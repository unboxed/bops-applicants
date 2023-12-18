# frozen_string_literal: true

class OwnershipCertificateValidationRequestsController < ValidationRequestsController
  before_action :set_validation_request
  before_action :set_planning_application

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
        @ownership_certificate_validation_request = build_validation_request
        format.html
      else
        format.html { render_not_found }
      end
    end
  end

  def update
    @ownership_certificate_validation_request = build_validation_request(ownership_certificate_validation_request_params)

    if ownership_certificate_validation_request_params[:approved] == "yes"
      redirect_to new_planning_application_ownership_certificate_path(params[:planning_application_id])
    else
      if @ownership_certificate_validation_request.update
        respond_to do |format|
          flash[:error] = error_message(@ownership_certificate_validation_request)
          format.html { render :edit }
        end
      end
    end
  end

  private

  def ownership_certificate_validation_request_params
    params.require(:ownership_certificate_validation_request).permit(:approved, :rejection_reason)
  end
end
