# frozen_string_literal: true

module Bops
  class ReplacementDocumentValidationRequest
    include ActiveModel::Model

    attr_accessor :file, :planning_application_id, :change_access_id, :id

    validates :file, presence: true

    class << self
      def find(id, planning_application_id, change_access_id)
        Apis::Bops::Client.get_replacement_document_validation_request(id, planning_application_id, change_access_id)
      end

      def replace_document(id, planning_application_id, change_access_id, file)
        Apis::Bops::Client.patch_replacement_document(id, planning_application_id, change_access_id, file)
      end
    end

    def update
      return false unless valid?

      self.class.replace_document(id, planning_application_id, change_access_id, file)
    end
  end
end
