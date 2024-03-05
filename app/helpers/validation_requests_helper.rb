# frozen_string_literal: true

module ValidationRequestsHelper
  def full_address(planning_application)
    [
      planning_application["site"]["address_1"],
      planning_application["site"]["town"],
      planning_application["site"]["postcode"]
    ].join(", ")
  end

  def date_received(planning_application)
    planning_application["created_at"].to_date.strftime("%e %B %Y")
  end

  def date_due(validation_request)
    validation_request["response_due"].to_date.strftime("%e %B %Y")
  end

  def latest_request_due(validation_requests)
    flattened_validation_requests(validation_requests).max_by { |x| x["response_due"] }
  end

  def flattened_validation_requests(validation_requests)
    validation_requests["data"]["additional_document_validation_requests"] +
      validation_requests["data"]["description_change_validation_requests"] +
      validation_requests["data"]["replacement_document_validation_requests"] +
      validation_requests["data"]["other_change_validation_requests"] +
      validation_requests["data"]["fee_change_validation_requests"] +
      validation_requests["data"]["red_line_boundary_change_validation_requests"] +
      validation_requests["data"]["ownership_certificate_validation_requests"] +
      validation_requests["data"]["pre_commencement_condition_validation_requests"] +
      validation_requests["data"]["heads_of_terms_validation_requests"]
  end

  def counter_change_requests_order(validation_request)
    if validation_request["data"]["description_change_validation_requests"].blank?
      "1."
    else
      "2."
    end
  end

  def ordered_validation_requests
    %w[description_change_validation_requests
      replacement_document_validation_requests
      additional_document_validation_requests
      red_line_boundary_change_validation_requests
      fee_change_validation_requests
      other_change_validation_requests
      ownership_certificate_validation_requests
      pre_commencement_condition_validation_requests
      heads_of_terms_validation_requests]
  end

  def count_total_requests(validation_requests, name)
    non_empty = validation_requests["data"].reject { |_k, v| v.empty? }
    ind = non_empty.keys.sort_by { |e| ordered_validation_requests.index(e) }.find_index(name)
    ind + 1
  end
end
