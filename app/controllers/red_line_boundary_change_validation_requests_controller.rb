# frozen_string_literal: true

class RedLineBoundaryChangeValidationRequestsController < ValidationRequestsController
  before_action :set_validation_request, :set_planning_application

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
        @red_line_boundary_change_validation_request = build_validation_request
        format.html
      else
        format.html { render_not_found }
      end
    end
  end

  def update
    @red_line_boundary_change_validation_request =
      build_validation_request(red_line_boundary_change_validation_request_params)

    respond_to do |format|
      if @red_line_boundary_change_validation_request.update
        flash[:notice] = t("shared.response_updated.success")
        format.html { validation_requests_redirect_url }
      else
        flash[:error] = error_message(@red_line_boundary_change_validation_request)
        format.html { render :edit }
      end
    end
  end

  private

  def red_line_boundary_change_validation_request_params
    params.require(:red_line_boundary_change_validation_request).permit(:approved, :rejection_reason)
  end
end
