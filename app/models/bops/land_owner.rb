# frozen_string_literal: true

module Bops
  class LandOwner
    class << self
      def create(planning_application_id, data:)
        Apis::Bops::Client.post_land_owner(
          planning_application_id:,
          ownership_certificate_id: data[:ownership_certificate_id],
          response: data
        )
      end
    end
  end
end
