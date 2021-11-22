# frozen_string_literal: true

module Bops
  class ValidationRequest
    class << self
      def find_all(planning_application_id, change_access_id)
        Apis::Bops::Client.get_validation_requests(planning_application_id, change_access_id)
      end

      ## To implement (we just want to build the minimum response required by the view)
      # def build(attributes)
      # end
    end
  end
end
