# frozen_string_literal: true

require "rails_helper"

RSpec.describe ValidationRequestsHelper, type: :helper do
  describe "latest_request_due" do
    it "finds the latest data if it is in description_change_validation_requests" do
      expect(latest_request_due({
        "data" => {
          "additional_document_validation_requests" => [
            {"response_due" => "2021-05-29"},
            {"response_due" => "2021-05-28"}
          ],
          "description_change_validation_requests" => [
            {"response_due" => "2021-06-10"},
            {"response_due" => "2021-06-12"}
          ],
          "replacement_document_validation_requests" => [
            {"response_due" => "2021-06-11"},
            {"response_due" => "2021-06-05"}
          ],
          "red_line_boundary_change_validation_requests" => [
            {"response_due" => "2021-06-04"},
            {"response_due" => "2021-06-02"}
          ],
          "other_change_validation_requests" => [
            {"response_due" => "2021-06-01"},
            {"response_due" => "2021-06-02"}
          ],
          "fee_change_validation_requests" => [
            {"response_due" => "2021-06-01"},
            {"response_due" => "2021-06-02"}
          ],
          "ownership_certificate_validation_requests" => [],
          "pre_commencement_condition_validation_requests" => [],
          "heads_of_terms_validation_requests" => []
        }
      })).to eq({"response_due" => "2021-06-12"})
    end

    it "finds the latest date if it is in replacement_document_validation_requests" do
      expect(latest_request_due({
        "data" => {
          "additional_document_validation_requests" => [
            {"response_due" => "2021-05-29"},
            {"response_due" => "2021-05-28"}
          ],
          "description_change_validation_requests" => [
            {"response_due" => "2021-06-10"},
            {"response_due" => "2021-06-04"}
          ],
          "replacement_document_validation_requests" => [
            {"response_due" => "2021-06-11"},
            {"response_due" => "2021-06-03"}
          ],
          "red_line_boundary_change_validation_requests" => [
            {"response_due" => "2021-06-04"},
            {"response_due" => "2021-06-02"}
          ],
          "other_change_validation_requests" => [
            {"response_due" => "2021-05-29"},
            {"response_due" => "2021-05-30"}
          ],
          "fee_change_validation_requests" => [
            {"response_due" => "2021-06-01"},
            {"response_due" => "2021-06-02"}
          ],
          "ownership_certificate_validation_requests" => [],
          "pre_commencement_condition_validation_requests" => [],
          "heads_of_terms_validation_requests" => []
        }
      })).to eq({"response_due" => "2021-06-11"})
    end

    it "finds the latest date if it is in red_line_boundary_change_validation_requests" do
      expect(latest_request_due({
        "data" => {
          "additional_document_validation_requests" => [
            {"response_due" => "2021-05-29"},
            {"response_due" => "2021-05-28"}
          ],
          "description_change_validation_requests" => [
            {"response_due" => "2021-06-10"},
            {"response_due" => "2021-06-04"}
          ],
          "replacement_document_validation_requests" => [
            {"response_due" => "2021-06-11"},
            {"response_due" => "2021-06-03"}
          ],
          "red_line_boundary_change_validation_requests" => [
            {"response_due" => "2021-07-12"},
            {"response_due" => "2021-06-02"}
          ],
          "other_change_validation_requests" => [
            {"response_due" => "2021-06-29"},
            {"response_due" => "2021-06-30"}
          ],
          "fee_change_validation_requests" => [
            {"response_due" => "2021-06-01"},
            {"response_due" => "2021-06-02"}
          ],
          "ownership_certificate_validation_requests" => [],
          "pre_commencement_condition_validation_requests" => [],
          "heads_of_terms_validation_requests" => []
        }
      })).to eq({"response_due" => "2021-07-12"})
    end

    it "finds the latest date if it is in other_change_validation_requests" do
      expect(latest_request_due({
        "data" => {
          "additional_document_validation_requests" => [
            {"response_due" => "2021-05-29"},
            {"response_due" => "2021-05-28"}
          ],
          "description_change_validation_requests" => [
            {"response_due" => "2021-06-10"},
            {"response_due" => "2021-06-04"}
          ],
          "replacement_document_validation_requests" => [
            {"response_due" => "2021-06-11"},
            {"response_due" => "2021-06-03"}
          ],
          "red_line_boundary_change_validation_requests" => [
            {"response_due" => "2021-04-12"},
            {"response_due" => "2021-06-02"}
          ],
          "other_change_validation_requests" => [
            {"response_due" => "2021-06-29"},
            {"response_due" => "2021-06-30"}
          ],
          "fee_change_validation_requests" => [
            {"response_due" => "2021-06-01"},
            {"response_due" => "2021-06-02"}
          ],
          "ownership_certificate_validation_requests" => [],
          "pre_commencement_condition_validation_requests" => [],
          "heads_of_terms_validation_requests" => []
        }
      })).to eq({"response_due" => "2021-06-30"})
    end

    it "finds the latest date if it is in additional_document_validation_requests" do
      expect(latest_request_due({
        "data" => {
          "additional_document_validation_requests" => [
            {"response_due" => "2021-07-01"},
            {"response_due" => "2021-07-02"}
          ],
          "description_change_validation_requests" => [
            {"response_due" => "2021-06-10"},
            {"response_due" => "2021-06-04"}
          ],
          "replacement_document_validation_requests" => [
            {"response_due" => "2021-06-11"},
            {"response_due" => "2021-06-03"}
          ],
          "red_line_boundary_change_validation_requests" => [
            {"response_due" => "2021-04-12"},
            {"response_due" => "2021-06-02"}
          ],
          "other_change_validation_requests" => [
            {"response_due" => "2021-06-29"},
            {"response_due" => "2021-06-30"}
          ],
          "fee_change_validation_requests" => [
            {"response_due" => "2021-06-01"},
            {"response_due" => "2021-06-02"}
          ],
          "ownership_certificate_validation_requests" => [],
          "pre_commencement_condition_validation_requests" => [],
          "heads_of_terms_validation_requests" => []
        }
      })).to eq({"response_due" => "2021-07-02"})
    end
  end
end
