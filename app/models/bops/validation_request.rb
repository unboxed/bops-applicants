# frozen_string_literal: true

module Bops
  class ValidationRequest
    class << self
      def find_all(planning_application_id, change_access_id)
        Apis::Bops::Client.get_validation_requests(planning_application_id, change_access_id)
      end
    end
  end
end
