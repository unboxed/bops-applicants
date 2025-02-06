# frozen_string_literal: true

require "rails_helper"

RSpec.describe "landing page", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit(
      validation_requests_path(
        planning_application_id: 28,
        change_access_id: 345_443_543
      )
    )
  end

  it "renders the application reference" do
    expect(page).to have_content("Application number: 22-00128-LDCP")
  end

  context "within phase-banner" do
    before do
      visit(
        validation_requests_path(
          planning_application_id: 28,
          change_access_id: 345_443_543
        )
      )
    end

    it "feedback link displayed with a reference to the user's email" do
      within find("a[href^='mailto:']") do
        expect(page).to have_content "feedback"
      end
    end
  end

  context "within footer" do
    it "lets the user navigate to accessibility page" do
      within("footer") { click_link("Accessibility statement") }

      expect(page).to have_content(
        "Accessibility statement for Default Council Back Office Planning System"
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
