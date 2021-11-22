# frozen_string_literal: true

module Bops
  class OtherChangeValidationRequest
    include ActiveModel::Model

    attr_accessor :response, :planning_application_id, :change_access_id, :id

    validates :response, presence: true

    class << self
      def respond(id, planning_application_id, change_access_id, response)
        Apis::Bops::Client.patch_response_other_change_request(id, planning_application_id, change_access_id, response)
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

      self.class.respond(id, planning_application_id, change_access_id, response)
    end
  end
end
