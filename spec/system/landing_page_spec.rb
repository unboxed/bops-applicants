require "rails_helper"

RSpec.describe "landing page", type: :system do
  let(:contact_details) do
    {
      default: {
        email_address: "planning@default.gov.uk",
        phone_number: "01234123123",
        postal_address: "Planning, 123 High Street, Big City, AB3 4EF",
      },
    }.deep_stringify_keys
  end

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    allow(YAML).to receive(:load_file).and_call_original

    allow(YAML)
      .to receive(:load_file)
      .with(Rails.root.join("config/contact_details.yml"))
      .and_return(contact_details)

    visit(
      validation_requests_path(
        planning_application_id: 28,
        change_access_id: 345_443_543,
      ),
    )
  end

  context "within phase-banner" do
    it "lets the user navigate to feedback" do
      within(".govuk-phase-banner") { expect(page).to have_link("feedback") }
    end
  end

  context "within footer" do
    it "lets the user navigate to accessibility page" do
      within("footer") { click_link("Accessibility statement") }

      expect(page).to have_content(
        "Accessibility statement for Default Council Back-office Planning System",
      )

      expect(page).to have_content("Email planning@default.gov.uk")
      expect(page).to have_content("Call 01234 123 123")
      expect(page).to have_content("123 High Street")
    end

    it "lets the user navigate to privacy policy page" do
      within("footer") { expect(page).to have_link("Privacy Policy") }
    end
  end
end
