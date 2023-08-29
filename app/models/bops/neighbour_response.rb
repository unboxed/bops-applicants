# frozen_string_literal: true

module Bops
  class NeighbourResponse
    OBJECTIONS = %i[
      design new_use privacy disabled_access
      noise traffic other
    ]

    class << self
      def create(planning_application_id, data:)
        Apis::Bops::Client.post_neighbour_response(
          planning_application_id, 
          name: data[:name], 
          response: construct_response(data), 
          address: data[:address],
          email: data[:email],
          summary_tag: data[:summary_tag]
        )
      end

      def construct_response(params)
        OBJECTIONS.map do |tag|
          next if params[:"#{tag}"].blank? 
          "#{tag.to_s.humanize}: #{params[:"#{tag}"]}\n"
        end.join
      end
    end
  end
end
