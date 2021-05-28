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
    flattened_change_requests(change_requests).max_by { |x| x["response_due"] }
  end

  def flattened_change_requests(change_requests)
    change_requests["data"]["description_change_requests"] + change_requests["data"]["document_change_requests"]
  end

  def counter_change_requests_order(change_request)
    if change_request["data"]["description_change_requests"].blank?
      "1."
    else
      "2."
    end
  end

  def counter_document_requests_order(change_request)
    if change_request["data"]["description_change_requests"].present? && change_request["data"]["document_change_requests"].present?
      "3."
    elsif change_request["data"]["description_change_requests"].present? || change_request["data"]["document_change_requests"].present?
      "2."
    else
      "1."
    end
  end
end
