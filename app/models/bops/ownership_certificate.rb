# frozen_string_literal: true

module Bops
  class OwnershipCertificate
    class << self
      def create(planning_application_id, data:, land_owners_attributes:)
        Apis::Bops::Client.post_ownership_certificate(
          planning_application_id,
          certificate_type: data[:certificate_type],
          land_owners_attributes:
        )
      end
    end
  end
end
