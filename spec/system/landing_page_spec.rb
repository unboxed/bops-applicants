require "rails_helper"

RSpec.describe "landing page", type: :system do
  include_context "local_authority_contact_details"

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
    stub_successful_get_change_requests
    stub_successful_get_planning_application

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
