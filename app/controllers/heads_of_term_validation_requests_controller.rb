# frozen_string_literal: true

class HeadsOfTermValidationRequestsController < ValidationRequestsController
  before_action :set_validation_request, :set_planning_application

  def edit
    respond_to do |format|
      if validation_request_is_open?
        @heads_of_term_validation_request = build_validation_request
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
    @heads_of_term_validation_request = Bops::HeadsOfTermValidationRequest.new(heads_of_term_validation_request_params)

    respond_to do |format|
      format.html do
        if @heads_of_term_validation_request.update
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

  def heads_of_term_validation_request_params
    params.require(:heads_of_term_validation_request)
      .permit(:approved, :rejection_reason, :id)
      .merge(
        planning_application_id: params[:planning_application_id],
        change_access_id: params[:change_access_id]
      )
  end
end
