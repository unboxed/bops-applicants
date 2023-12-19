# frozen_string_literal: true

class LandOwnersController < ApplicationController
  before_action :set_planning_application, :set_certificate

  def new
    @land_owner = LandOwner.new()
  end

  def create
    @land_owner = LandOwner.new(land_owner_params.except(:change_access_id))

    if @land_owner.save
      redirect_to planning_application_ownership_certificate_path(
        @planning_application["id"], 
        @ownership_certificate, 
        change_access_id: land_owner_params[:change_access_id]
      )
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  private

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end

  def set_certificate
    @ownership_certificate = OwnershipCertificate.find(params[:ownership_certificate_id])
  end

  def land_owner_params
    params.require(:land_owner)
      .permit(:name, :address_1, :address_2, :town, :country, :postcode, :notice_given_at, :change_access_id)
      .to_h.merge(ownership_certificate_id: @ownership_certificate.id)
  end
end
