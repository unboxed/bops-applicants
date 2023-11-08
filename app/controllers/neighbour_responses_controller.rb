# frozen_string_literal: true

class NeighbourResponsesController < ApplicationController
  before_action :build_response, :set_planning_application, only: %i[new create]
  before_action :set_planning_application
  before_action :ensure_no_decision

  RESPONSE_PARAMS = [
    :name, :email, :address, :response, :summary_tag, :design, :final_check,
    :use, :privacy, :light, :access, :noise, :traffic, :other, :tags, {files: []},
    {tags: []}
  ].freeze

  PERMITTED_PARAMS = [:stage, :move_next, :move_back, :planning_application_id,
    {neighbour_response: RESPONSE_PARAMS}].freeze

  def start
  end

  def thank_you
  end

  def new
  end

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
    @new_response = NeighbourResponse.new(flattened_params)
  end

  def flattened_params
    return {} if neighbour_response_params[:neighbour_response].nil?

    hash = {}
    neighbour_response_params[:neighbour_response].each do |key, value|
      hash[key] = value
    end

    neighbour_response_params.merge!(hash)
  end

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end

  def neighbour_response_params
    params.permit(PERMITTED_PARAMS)
  end

  def ensure_no_decision
    return unless @planning_application["decision"].presence

    render plain: "Not Found", status: :not_found
  end
end
