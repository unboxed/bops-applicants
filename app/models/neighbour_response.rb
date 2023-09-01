# frozen_string_literal: true

class NeighbourResponse
  include ActiveModel::Model

  STAGES = %w[about_you thoughts response check].freeze

  TAGS = %i[design use privacy light access noise traffic other].freeze
  RESPONSE_PARAMS  = [:name, :email, :address, :response, :summary_tag, TAGS, :tags, { tags: [] }].freeze
  PERMITTED_PARAMS = [:stage, :move_next, :move_back, :planning_application_id,
                      { neighbour_response: RESPONSE_PARAMS }].freeze

  attr_reader :params, :errors

  def initialize(params)
    @params = params.permit(*PERMITTED_PARAMS)
    @errors = ActiveModel::Errors.new(self)
  end

  def stage
    @stage ||= stage_param.in?(STAGES) ? stage_param : STAGES.first
  end

  def name
    response_params[:name].to_s.strip
  end

  def email
    response_params[:email].to_s.strip
  end

  def address
    response_params[:address].to_s.strip
  end

  def summary_tag
    response_params[:summary_tag].to_s.strip
  end

  TAGS.each do |tag|
    define_method(tag) do
      response_params[:"#{tag}"].to_s.strip
    end
  end

  def tags
    response_params[:tags]
  end

  def save
    @stage = previous_stage and return false if moving_backwards?

    return false unless valid?

    @stage = next_stage and return false unless done?

    response_data = ActionController::Parameters.new(
      name:, email:, address:, summary_tag:, use:,
      privacy:, light:, access:, noise:, traffic:,
      other:, tags:
    )

    Bops::NeighbourResponse.create(
      params[:planning_application_id],
      data: response_data
    )

    true
  end

  def done?
    stage == "check"
  end

  private

  def next_stage
    STAGES[[stage_index + 1, 3].min]
  end

  def stage_index
    STAGES.index(stage)
  end

  def moving_backwards?
    params.key?(:move_back)
  end

  def previous_stage
    STAGES[[stage_index - 1, 0].max]
  end

  def valid?
    errors.clear
    validate_response
    errors.empty?
  end

  def validate_response # rubocop:disable Metrics/CyclomaticComplexity
    errors.add(:name, :blank, message: "Enter your name") if stage == "about_you" && name.blank?

    if stage == "thoughts" && summary_tag.blank?
      errors.add(:summary_tag, :blank,
                 message: "Select how you feel about the application")
    end

    errors.add(:tags, :blank, message: "Enter a comment") if stage == "tags" && !information_filled?

    @stage = stage if errors.any?
  end

  def stage_param
    @stage_param ||= params[:stage].to_s
  end

  def response_params
    params[:neighbour_response] || {}
  end

  def information_filled?
    TAGS.each do |tag|
      send(tag).present?
    end
  end
end
