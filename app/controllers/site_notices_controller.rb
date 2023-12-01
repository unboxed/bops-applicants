# frozen_string_literal: true

class SiteNoticesController < ApplicationController
  include Api::ErrorHandler

  before_action :set_planning_application

  def download
    if @planning_application["make_public"]
      respond_to do |format|
        format.html
      end
    else
      render_not_found
    end
  end

  private

  def render_not_found
    render plain: "Not Found", status: :not_found
  end

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end
end
