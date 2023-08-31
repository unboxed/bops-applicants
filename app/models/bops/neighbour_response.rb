# frozen_string_literal: true

module Bops
  class NeighbourResponse
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
        params[:tags].each do |tag|
          "#{tag.to_s.humanize}: #{params[:"#{tag}"]}\n"
        end.join 
        
        if params[:other_comments].present?
          response = response + "/n #{params[:other_comments]}"
        end

        response
      end
    end
  end
end
