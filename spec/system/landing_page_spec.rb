# frozen_string_literal: true

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
        change_access_id: 345_443_543
      )
    )
  end

  it "renders the application reference" do
    expect(page).to have_content("Application number: 22-00100-LDCP")
  end

  context "within phase-banner" do
    context "when FEEDBACK_FISH_ID env variable is set" do
      before do
        ENV["FEEDBACK_FISH_ID"] = "randomid123"

        visit(
          validation_requests_path(
            planning_application_id: 28,
            change_access_id: 345_443_543
          )
        )
      end

      it "is displayed with a reference to the user's email" do
        within find("a[data-feedback-fish][data-feedback-fish-userid='agent@example.com']") do
          expect(page).to have_content "feedback"
        end
      end
    end

    context "when FEEDBACK_FISH_ID env variable is not set" do
      before do
        ENV["FEEDBACK_FISH_ID"] = nil

        visit(
          validation_requests_path(
            planning_application_id: 28,
            change_access_id: 345_443_543
          )
        )
      end

      it "is not displayed" do
        within(".govuk-phase-banner__content") do
          expect(page).not_to have_content "feedback"
        end
      end
    end
  end

  context "within footer" do
    it "lets the user navigate to accessibility page" do
      within("footer") { click_link("Accessibility statement") }

      expect(page).to have_content(
        "Accessibility statement for Default Council Back-office Planning System"
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
