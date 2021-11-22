# frozen_string_literal: true

module Bops
  class AdditionalDocumentValidationRequest
    include ActiveModel::Model

    attr_accessor :file, :planning_application_id, :change_access_id, :id

    validates :file, presence: true

    class << self
      def add_document(id, planning_application_id, change_access_id, file)
        Apis::Bops::Client.patch_additional_document(id, planning_application_id, change_access_id, file)
      end

      ## To implement (when we add a show /:id endpoint)
      # def find(id, planning_application_id)
      # end

      ## To implement (we just want to build the minimum response required by the view)
      # def build(attributes)
      # end
    end

    def update
      return false unless valid?

      self.class.add_document(id, planning_application_id, change_access_id, file)
    end
  end
end
