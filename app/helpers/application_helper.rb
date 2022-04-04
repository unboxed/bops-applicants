module ApplicationHelper
  FEEDBACK_EMAILS = {
    lambeth: "digitalplanning@lambeth.gov.uk",
    southwark: "digital.projects@southwark.gov.uk",
    buckinghamshire: "planning.digital@buckinghamshire.gov.uk",
  }.freeze

  def feedback_email(current_local_authority)
    FEEDBACK_EMAILS[current_local_authority.to_sym]
  end
end
