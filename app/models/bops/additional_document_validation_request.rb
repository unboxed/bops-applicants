# frozen_string_literal: true

module Bops
  class AdditionalDocumentValidationRequest
    include ActiveModel::Model

    attr_accessor :files, :planning_application_id, :change_access_id, :id

    validates :files, presence: true

    class << self
      def find(id, planning_application_id, change_access_id)
        Apis::Bops::Client.get_additional_document_validation_request(id, planning_application_id, change_access_id)
      end

      def add_documents(id, planning_application_id, change_access_id, files)
        Apis::Bops::Client.patch_additional_documents(id, planning_application_id, change_access_id, files)
      end
    end

    def update
      return false unless valid?

      self.class.add_documents(id, planning_application_id, change_access_id, files)
    end
  end
end
