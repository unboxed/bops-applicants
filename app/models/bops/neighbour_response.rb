# frozen_string_literal: true

module Bops
  class NeighbourResponse
    class << self
      def create(planning_application_id, data:)
        Apis::Bops::Client.post_neighbour_response(
          planning_application_id, 
          name: data[:name], 
          response: data[:response], 
          address: data[:address],
          email: data[:email],
          summary_tag: data[:summary_tag],
          tags: data[:tags].reject(&:blank?)
        )
      end
    end
  end
end
