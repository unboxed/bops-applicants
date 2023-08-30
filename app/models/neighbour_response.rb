class NeighbourResponse
  include ActiveModel::Model

  STAGES = %w[about_you thoughts tags other_comments]

  RESPONSE_PARAMS  = [:name, :email, :address, :response, :summary_tag, :design, :new_use, :privacy, :disabled_access, :noise, :traffic, :other, :other_comments]
  PERMITTED_PARAMS = [:stage, :move_next, :planning_application_id, neighbour_response: RESPONSE_PARAMS]

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

  def design
    response_params[:design].to_s.strip
  end

  def new_use
    response_params[:new_use].to_s.strip
  end

  def privacy
    response_params[:privacy].to_s.strip
  end

  def disabled_access
    response_params[:disabled_access].to_s.strip
  end

  def noise
    response_params[:noise].to_s.strip
  end

  def traffic
    response_params[:traffic].to_s.strip
  end

  def other
    response_params[:other].to_s.strip
  end

  def tags
    response_params[:tags].to_s
  end

  def other_comments
    response_params[:other_comments].to_s.strip
  end

  def stage
    @stage ||= stage_param.in?(STAGES) ? stage_param : STAGES.first
  end

  def save
    unless valid?
      return false
    end

    if done?
      response_data =  ActionController::Parameters.new(
        name:,
        email:,
        address:,
        summary_tag:,
        new_use:,
        privacy:,
        disabled_access:,
        noise:,
        traffic:,
        other:,
        other_comments:
      )

      Bops::NeighbourResponse.create(
        params[:planning_application_id], 
        data: response_data
      )

      return true
    else
      @stage = next_stage and return false
    end
  end

  def done?
    stage == "other_comments"
  end

  def next_stage
    STAGES[[stage_index + 1, 3].min]
  end

  def stage_index
    STAGES.index(stage)
  end

  private

  def valid?
    errors.clear
    validate_response
    errors.empty?
  end

  def validate_response
    errors.add(:name, :blank) unless name.present? if stage == "about_you"
    errors.add(:summary_tag, :blank) unless summary_tag.present? if stage == "thoughts"

    if stage == "tags"
      errors.add(:tags, :blank, message: "You must fill in your reason") unless information_filled?
    end

    if errors.any?
      @stage = stage
    end
  end

  def stage_param
    @stage_param ||= params[:stage].to_s
  end

  def response_params
    params[:neighbour_response] || {}
  end

  def information_filled?
    design.present? || new_use.present? || privacy.present? || disabled_access.present? ||
      noise.present? || traffic.present? || other.present?
  end
end
