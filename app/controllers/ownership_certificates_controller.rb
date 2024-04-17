# frozen_string_literal: true

class OwnershipCertificatesController < ApplicationController
  before_action :set_planning_application
  before_action :set_certificate, except: %i[new create]
  before_action :set_validation_request, only: %i[new create submit]

  def new
    @ownership_certificate = OwnershipCertificate.new(planning_application_id: @planning_application["id"])
  end

  def show
  end

  def edit
  end

  def update
    if @ownership_certificate.update(ownership_certificate_params)
      redirect_to planning_application_ownership_certificate_path(
        @planning_application["id"],
        @ownership_certificate,
        change_access_id: @ownership_certificate.change_access_id
      )
    else
      respond_to do |format|
        format.html do
          set_validation_request
          render :edit
        end
      end
    end
  end

  def create
    @ownership_certificate = OwnershipCertificate.new(ownership_certificate_params)

    if @ownership_certificate.save
      redirect_to planning_application_ownership_certificate_path(
        @planning_application["id"],
        @ownership_certificate
      )
    else
      respond_to do |format|
        format.html do
          set_validation_request
          render :new
        end
      end
    end
  end

  def thank_you
  end

  def submit
    if Bops::OwnershipCertificateValidationRequest.approve(
      @ownership_certificate_validation_request["id"],
      @planning_application["id"],
      @ownership_certificate.change_access_id,
      params: {
        certificate_type: @ownership_certificate.certificate_type,
        land_owners_attributes: @ownership_certificate.relevant_land_owners_attributes
      }
    )

      redirect_to validation_requests_redirect_url
    else
      render :show
    end
  end

  private

  def set_certificate
    @ownership_certificate = OwnershipCertificate.find(params[:ownership_certificate_id] || params[:id])
  end

  def set_planning_application
    @planning_application ||= Bops::PlanningApplication.find(params[:planning_application_id])
  end

  def ownership_certificate_params
    params.require(:ownership_certificate)
      .permit(:know_owners, :number_of_owners, :certificate_type, :notification_of_owners, :change_access_id)
      .to_h.merge(planning_application_id: @planning_application["id"])
  end

  def set_validation_request
    @change_access_id = if params.has_key?(:change_access_id)
      params[:change_access_id]
    else
      ownership_certificate_params[:change_access_id]
    end

    validation_requests = Apis::Bops::Client.get_validation_requests(@planning_application["id"], @change_access_id)
    @ownership_certificate_validation_request ||= validation_requests["data"]["ownership_certificate_validation_requests"].last
  end
end
