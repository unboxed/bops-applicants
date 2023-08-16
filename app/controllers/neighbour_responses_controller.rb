# frozen_string_literal: true

class NeighbourResponsesController < ApplicationController
  before_action :set_planning_application

  def new
    @objections = [
      OpenStruct.new(name: "design", description: "The design, size and height of new buildings or extensions"), 
      OpenStruct.new(name: "new_use", description: "The impact of new uses of buildings or of land"), 
      OpenStruct.new(name: "privacy", description: "Loss of light and the privacy of neighbours"), 
      OpenStruct.new(name: "disabled_access", description: "Access for disabled people"), 
      OpenStruct.new(name: "noise", description: "Noise from new uses"), 
      OpenStruct.new(name: "traffic", description: "The impact of development on traffic parking and road safety"),
      OpenStruct.new(name: "other", description: "Other")
    ]
  end

  def create
    Bops::NeighbourResponse.create(
      @planning_application["id"], 
      data: response_params
    )

    redirect_to planning_application_path(@planning_application["id"]), notice: "Your response has been submitted"
  end

  private

  def response_params
    params.require(:neighbour_response)
      .permit(:name, :email, :response, :address, :summary_tag, tags: [])
  end

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end
end
