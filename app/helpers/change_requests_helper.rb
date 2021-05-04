# frozen_string_literal: true

module ChangeRequestsHelper
  def full_address(planning_application)
    "#{planning_application['site']['address_1']}, #{planning_application['site']['town']}, #{planning_application['site']['postcode']}"
  end

  def reference(planning_application)
    planning_application["id"].to_s.rjust(8, "0")
  end

  def date_received(planning_application)
    planning_application["created_at"].to_date.strftime("%e %B %Y")
  end

  def date_due(change_request)
    change_request["response_due"].to_date.strftime("%e %B %Y")
  end

  def latest_request_due(change_requests)
    change_requests["data"].min { |a, b| b["response_due"] <=> a["response_due"] }
  end
end
