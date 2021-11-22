# frozen_string_literal: true

module Bops
  class PlanningApplication
    class << self
      def find(planning_application_id)
        Apis::Bops::Client.get_planning_application(planning_application_id)
      end

      ## To implement (we just want to build the minimum response required by the view)
      # def build(attributes)
      # end
    end
  end
end
