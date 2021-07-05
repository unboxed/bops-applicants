# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChangeRequestsHelper, type: :helper do
  describe "latest_request_due" do
    it "finds the latest data if it is in description_change_requests" do
      expect(latest_request_due({
        "data" => {
          "description_change_requests" => [
            { "response_due" => "2021-06-10" },
            { "response_due" => "2021-06-12" },
          ],
          "document_change_requests" => [
            { "response_due" => "2021-06-11" },
            { "response_due" => "2021-06-05" },
          ],
          "red_line_boundary_change_requests" => [
            { "response_due" => "2021-06-04" },
            { "response_due" => "2021-06-02" },
          ],
          "other_change_validation_requests" => [
            { "response_due" => "2021-06-01" },
            { "response_due" => "2021-06-02" },
          ],
        },
      })).to eq({ "response_due" => "2021-06-12" })
    end

    it "finds the latest date if it is in document_change_requests" do
      expect(latest_request_due({
        "data" => {
          "description_change_requests" => [
            { "response_due" => "2021-06-10" },
            { "response_due" => "2021-06-04" },
          ],
          "document_change_requests" => [
            { "response_due" => "2021-06-11" },
            { "response_due" => "2021-06-03" },
          ],
          "red_line_boundary_change_requests" => [
            { "response_due" => "2021-06-04" },
            { "response_due" => "2021-06-02" },
          ],
          "other_change_validation_requests" => [
            { "response_due" => "2021-05-29" },
            { "response_due" => "2021-05-30" },
          ],
        },
      })).to eq({ "response_due" => "2021-06-11" })
    end

    it "finds the latest date if it is in red_line_boundary_change_requests" do
      expect(latest_request_due({
        "data" => {
          "description_change_requests" => [
            { "response_due" => "2021-06-10" },
            { "response_due" => "2021-06-04" },
          ],
          "document_change_requests" => [
            { "response_due" => "2021-06-11" },
            { "response_due" => "2021-06-03" },
          ],
          "red_line_boundary_change_requests" => [
            { "response_due" => "2021-07-12" },
            { "response_due" => "2021-06-02" },
          ],
          "other_change_validation_requests" => [
            { "response_due" => "2021-06-29" },
            { "response_due" => "2021-06-30" },
          ],
        },
      })).to eq({ "response_due" => "2021-07-12" })
    end

    it "finds the latest date if it is in other_change_validation_requests" do
      expect(latest_request_due({
        "data" => {
          "description_change_requests" => [
            { "response_due" => "2021-06-10" },
            { "response_due" => "2021-06-04" },
          ],
          "document_change_requests" => [
            { "response_due" => "2021-06-11" },
            { "response_due" => "2021-06-03" },
          ],
          "red_line_boundary_change_requests" => [
            { "response_due" => "2021-04-12" },
            { "response_due" => "2021-06-02" },
          ],
          "other_change_validation_requests" => [
            { "response_due" => "2021-06-29" },
            { "response_due" => "2021-06-30" },
          ],
        },
      })).to eq({ "response_due" => "2021-06-30" })
    end
  end
end
