# frozen_string_literal: true

class PlanningApplicationsController < ApplicationController
  include Api::ErrorHandler

  before_action :set_planning_application
  before_action :set_local_authority
  before_action :set_documents
  before_action :set_base_url

  def show
    logger.info("\n\n\n***** I've reached the actual show method *****\n\n\n")
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
    @planning_application = Bops::PlanningApplication.find(params[:id])
    logger.info("\n\n\n***** Current planning application id: #{@planning_application} *****\n\n\n")
  end

  def set_local_authority
    logger.info("\n\n\n***** Current local authority: #{Current.local_authority} *****\n\n\n")
    @local_authority = Bops::LocalAuthority.find(Current.local_authority)
  end

  def set_documents
    @documents = @planning_application["documents"]
  end

  def set_base_url
    @base_url = "#{Rails.configuration.api_protocol}://#{Current.local_authority}.#{Rails.configuration.api_host}"
  end

  def set_header_link
    @header_link = planning_application_path(id: params["id"])
  end
end
