# frozen_string_literal: true

class NeighbourResponsesController < ApplicationController
  before_action :set_planning_application

  def new
  end

  def create
    Bops::NeighbourResponse.create(
      @planning_application["id"], 
      data: response_params,
      address: params[:"input-autocomplete"]
    )

    redirect_to planning_application_path(@planning_application["id"]), notice: "Your response has been submitted"
  end

  private

  def response_params
    params.require(:neighbour_response)
      .permit(:name, :email, :response, :summary_tag, :design, :new_use, :privacy, :disabled_access, :noise, :traffic, :other, tags: [])
  end

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end
end
