# frozen_string_literal: true

class PlanningApplicationsController < ApplicationController
  include Api::ErrorHandler

  before_action :set_planning_application
  before_action :set_local_authority
  before_action :set_documents
  before_action :set_base_url

  def show
    respond_to do |format|
      format.html
    end
  end

  def render_not_found
    render plain: "Not Found", status: :not_found
  end

  private

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:id])
  end

  def set_local_authority
    @local_authority = Bops::LocalAuthority.find(Current.local_authority)
  end

  def set_documents
    @documents = @planning_application["documents"]
  end

  def set_base_url
    @base_url = "#{ENV.fetch('PROTOCOL', nil)}://#{Current.local_authority}.#{ENV.fetch('API_HOST', 'bops-care.link')}"
  end
end
