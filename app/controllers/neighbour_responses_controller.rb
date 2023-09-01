# frozen_string_literal: true

class NeighbourResponsesController < ApplicationController
  before_action :build_response, :set_planning_application, only: %i[new create]
  before_action :set_planning_application

  def start; end

  def thank_you; end

  def new; end

  def create
    if @new_response.save
      redirect_to thank_you_planning_application_neighbour_responses_path(params[:planning_application_id])
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  private

  def build_response
    @new_response = NeighbourResponse.new(params)
  end

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end
end
