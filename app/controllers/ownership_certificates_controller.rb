# frozen_string_literal: true

class OwnershipCertificatesController < ApplicationController
  before_action :set_planning_application
  before_action :set_certificate, except: %i[new create]

  def new
    @ownership_certificate = OwnershipCertificate.new(planning_application_id: @planning_application["id"])
  end

  def show
  end

  def create
    @ownership_certificate = OwnershipCertificate.new(ownership_certificate_params)

    if @ownership_certificate.save
      redirect_to planning_application_ownership_certificate_path(@planning_application["id"], @ownership_certificate)
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def thank_you
  end

  def submit
    if Bops::OwnershipCertificate.create(
      params[:planning_application_id],
      data: @ownership_certificate,
      land_owners_attributes: @ownership_certificate.land_owners
    )
      redirect_to thank_you_planning_application_ownership_certificates_path(@planning_application["id"], @ownership_certificate)
    else
      render :show
    end
  end

  private

  def set_certificate
    if params[:ownership_certificate_id]
      @ownership_certificate = OwnershipCertificate.find(params[:ownership_certificate_id])
    else
      @ownership_certificate = OwnershipCertificate.find(params[:id])
    end
  end

  def set_planning_application
    @planning_application = Bops::PlanningApplication.find(params[:planning_application_id])
  end

  def ownership_certificate_params
    params.require(:ownership_certificate)
      .permit(:know_owners, :number_of_owners, :certificate_type, :notification_of_owners)
      .to_h.merge(planning_application_id: @planning_application["id"])
  end
end
