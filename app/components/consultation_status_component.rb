# frozen_string_literal: true

class ConsultationStatusComponent < ViewComponent::Base
  DECISIONS_GRANTED = %w[granted granted_not_required].freeze
  DECISION_REFUSED = "refused"
  STATUSES_CLOSED = %w[closed withdrawn cancelled].freeze

  def initialize(planning_application:)
    @planning_application = planning_application
  end

  def status_tag
    content_tag :span, status_text, class: status_classes
  end

  private

  attr_reader :planning_application

  def status_classes
    ["govuk-tag govuk-tag--#{status_tag_colour}"]
  end

  def status_text
    decision_text.presence || undetermined_status
  end

  def decision_text
    planning_application["decision"]&.humanize
  end

  def undetermined_status
    return "closed" if planning_application_closed?

    consultation_in_progress? ? "under consultation" : "in review"
  end

  def status_tag_colour
    return "green" if planning_application_granted?
    return "red" if planning_application["decision"] == "refused"
    "grey"
  end

  def consultation_in_progress?
    return unless planning_application.dig("consultation", "end_date")

    planning_application["consultation"]["end_date"].to_time > Time.current
  end

  def planning_application_closed?
    STATUSES_CLOSED.include?(planning_application["status"])
  end

  def planning_application_granted?
    DECISIONS_GRANTED.include?(planning_application["decision"])
  end

  def consultation_end_date
    raise ArgumentError, "No consultation end date exists" unless planning_application.dig("consultation", "end_date")

    @consultation_end_date ||= format_datetime(planning_application["consultation"]["end_date"])
  end

  def format_datetime(datetime_str)
    datetime = DateTime.parse(datetime_str)
    datetime.strftime("%-d %B %Y")
  end

  def decision_notice_link
    "#{ENV["PROTOCOL"]}://#{Current.local_authority}.#{ENV["API_HOST"]}/public/planning_applications/#{planning_application["id"]}/decision_notice"
  end
end
