# frozen_string_literal: true

class DescriptionChangeValidationRequestsController < ValidationRequestsController
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
        @description_change_validation_request = build_validation_request
        format.html
      else
        format.html { render_not_found }
      end
    end
  end

  def update
    @description_change_validation_request = build_validation_request(description_change_validation_request_params)

    respond_to do |format|
      if @description_change_validation_request.update
        format.html do
          redirect_to validation_requests_path(
            planning_application_id: params[:planning_application_id],
            change_access_id: params[:change_access_id]
          ), notice: t("shared.response_updated.success")
        end
      else
        format.html { render :edit }
      end
    end
  end

  private

  def description_change_validation_request_params
    params.require(:description_change_validation_request).permit(:approved, :rejection_reason)
  end
end
