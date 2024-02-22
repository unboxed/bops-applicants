# frozen_string_literal: true

class PreCommencementConditionValidationRequestsController < ValidationRequestsController
  before_action :set_validation_request

  def edit
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

  def update
    @pre_commencement_condition_validation_request = Bops::PreCommencementConditionValidationRequest.new(pre_commencement_condition_validation_request_params)

    respond_to do |format|
      if @pre_commencement_condition_validation_request.update
        flash[:notice] = t("shared.response_updated.success")
        format.html { validation_requests_redirect_url }
      else
        flash[:error] = error_message(@pre_commencement_condition_validation_request)
        format.html { render :index }
      end
    end
  end

  private

  def pre_commencement_condition_validation_request_params
    params.require(:pre_commencement_condition_validation_request)
      .permit(:approved, :rejection_reason, :id)
      .merge(
        planning_application_id: params[:planning_application_id],
        change_access_id: params[:change_access_id]
      )
  end
end
