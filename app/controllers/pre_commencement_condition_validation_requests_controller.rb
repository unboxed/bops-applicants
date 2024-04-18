# frozen_string_literal: true

class PreCommencementConditionValidationRequestsController < ValidationRequestsController
  before_action :set_validation_request, :set_planning_application

  def edit
    respond_to do |format|
      if validation_request_is_open?
        @pre_commencement_condition_validation_request = build_validation_request
        format.html
      else
        format.html { render_not_found }
      end
    end
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

  def pre_commencement_condition_validation_request_params
    params.require(:pre_commencement_condition_validation_request)
      .permit(:approved, :rejection_reason, :id)
      .merge(
        planning_application_id: params[:planning_application_id],
        change_access_id: params[:change_access_id]
      )
  end
end
