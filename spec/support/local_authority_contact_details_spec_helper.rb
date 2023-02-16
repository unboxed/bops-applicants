# frozen_string_literal: true

require "rails_helper"

RSpec.shared_context "local_authority_contact_details" do
  let(:local_authority) do
    {
      default: {
        email_address: "planning@default.gov.uk",
        feedback_email: "planning@default.gov.uk",
        phone_number: "01234123123",
        postal_address: "Planning, 123 High Street, Big City, AB3 4EF",
        privacy_policy: "https://www.default.gov.uk/privacy-policy"
      }
    }.deep_stringify_keys
  end

  before do
    allow(YAML).to receive(:load_file).and_call_original

    allow(YAML)
      .to receive(:load_file)
      .with(Rails.root.join("config/contact_details.yml"))
      .and_return(local_authority)
  end
end
