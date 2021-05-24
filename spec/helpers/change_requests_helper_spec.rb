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
        },
      })).to eq({ "response_due" => "2021-06-11" })
    end
  end
end
