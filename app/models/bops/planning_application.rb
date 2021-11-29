# frozen_string_literal: true

module Bops
  class PlanningApplication
    class << self
      def find(planning_application_id)
        Apis::Bops::Client.get_planning_application(planning_application_id)
      end
    end
  end
end
