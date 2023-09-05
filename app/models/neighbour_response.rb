# frozen_string_literal: true

class NeighbourResponse
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :neighbour_response
  attribute :name
  attribute :email
  attribute :address
  attribute :response
  attribute :summary_tag
  attribute :tags, array: true, default: []
  attribute :design
  attribute :use
  attribute :privacy
  attribute :light
  attribute :access
  attribute :noise
  attribute :traffic
  attribute :other
  attribute :stage
  attribute :move_next
  attribute :move_back
  attribute :final_check
  attribute :planning_application_id, :integer

  STAGES = %w[about_you thoughts response check].freeze

  validates :name, presence: true, if: :about_you_stage?
  validates :summary_tag, presence: true, if: :thoughts_stage?
  validate :at_least_one_comment, if: -> { response_stage? && information_not_filled? }

  attr_reader :params

  def initialize(params)
    super(params)
    @params = params
  end

  def stage
    @stage ||= stage_param.in?(STAGES) ? stage_param : STAGES.first
  end

  def save
    @stage = if moving_backwards?
               previous_stage
             elsif invalid?
               stage
             else
               next_stage
             end

    return false unless done? && final_check

    response_data = ActionController::Parameters.new(
      name:, email:, address:, summary_tag:, use:,
      privacy:, light:, access:, noise:, traffic:,
      other:, tags:
    )

    if Bops::NeighbourResponse.create(
      params[:planning_application_id],
      data: response_data
    )
      true
    else
      false
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity

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

  def stage_param
    @stage_param ||= params[:stage].to_s
  end

  def response_params
    params[:neighbour_response] || {}
  end

  def information_not_filled? # rubocop:disable Metrics/CyclomaticComplexity
    design.blank? && use.blank? && light.blank? && privacy.blank? &&
      access.blank? && noise.blank? && traffic.blank? && other.blank?
  end

  def at_least_one_comment
    errors.add(:tags, :blank)
  end

  def about_you_stage?
    stage == "about_you"
  end

  def thoughts_stage?
    stage == "thoughts"
  end

  def response_stage?
    stage == "response"
  end
end
