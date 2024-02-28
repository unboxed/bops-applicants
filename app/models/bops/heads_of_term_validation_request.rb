# frozen_string_literal: true

module Bops
  class HeadsOfTermValidationRequest
    include ActiveModel::Model

    attr_accessor :approved, :rejection_reason, :planning_application_id, :change_access_id, :id

    validates :approved, presence: true
    validates :rejection_reason, presence: true, if: :not_approved?

    class << self
      def find(id, planning_application_id, change_access_id)
        Apis::Bops::Client.get_heads_of_terms_validation_request(id, planning_application_id,
          change_access_id)
      end

      def approve(id, planning_application_id, change_access_id)
        Apis::Bops::Client.patch_approved_heads_of_terms_validation_request(id, planning_application_id, change_access_id)
      end

      def reject(id, planning_application_id, change_access_id, rejection_reason)
        Apis::Bops::Client.patch_rejected_heads_of_terms_validation_request(id, planning_application_id, change_access_id,
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
