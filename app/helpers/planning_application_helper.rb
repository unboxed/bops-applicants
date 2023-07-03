# frozen_string_literal: true

module PlanningApplicationHelper
  COLOURS = {
    supportive: "green",
    objection: "red",
    neutral: "yellow"
  }.freeze

  def tag_colour(tag)
    COLOURS[tag.to_sym]
  end
end
