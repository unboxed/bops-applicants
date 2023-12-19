# frozen_string_literal: true

module Bops
  class OwnershipCertificateValidationRequest
    include ActiveModel::Model

    attr_accessor :approved, :rejection_reason, :planning_application_id, :change_access_id, :id

    validates :approved, presence: true
    validates :rejection_reason, presence: true, if: :not_approved?

    class << self
      def find(id, planning_application_id, change_access_id)
        Apis::Bops::Client.get_ownership_certificate_validation_request(id, planning_application_id, change_access_id)
      end

      def approve(id, planning_application_id, change_access_id, params)
        Apis::Bops::Client.patch_approved_ownership_certificate(id, planning_application_id, change_access_id, params)
      end

      def reject(id, planning_application_id, change_access_id, rejection_reason)
        Apis::Bops::Client.patch_rejected_ownership_certificate(id, planning_application_id, change_access_id,
          rejection_reason)
      end
    end

    def update
      return false unless valid?

      if approved?
        self.class.approve(id, planning_application_id, change_access_id)
      elsif not_approved?
        self.class.reject(id, planning_application_id, change_access_id, rejection_reason)
      else
        false
      end
    end

    private

    def not_approved?
      approved == "no"
    end

    def approved?
      approved == "yes"
    end
  end
end
