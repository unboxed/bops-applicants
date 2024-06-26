# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Other change requests", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"

    stub_successful_get_planning_application
    stub_get_other_change_validation_request(
      id: 19,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          id: 19,
          state: "open",
          reason: "You applied for the wrong sort of certificate",
          suggestion: "Please confirm you want a Lawful Development certificate",
          response_due: "2022-7-1"
        },
      status: 200
    )
  end

  context "when state is open" do
    before do
      stub_patch_other_change_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        response: "Agreed",
        status: 200
      )
    end

    it "allows the user to provide a response" do
      visit "/other_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content(
        "You must submit your response by 1 July 2022. If we don’t receive a response by this date we will return your application to you and refund any payment."
      )

      expect(page).to have_content("You applied for the wrong sort of certificate")
      expect(page).to have_content("Please confirm you want a Lawful Development certificate")

      fill_in "Respond to this request", with: "Agreed"

      stub_successful_get_change_requests
      click_button "Submit"

      expect(page).to have_content("Your response has been sent to the case officer.")
    end

    it "can't view show action" do
      visit "/other_change_validation_requests/19?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "does not allow the user to submit a blank response" do
      visit "/other_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      click_button "Submit"
      within(".govuk-error-summary") do
        expect(page).to have_content "Enter your response to the planning officer's question."
      end
    end

    it "has the correct page title" do
      visit "/other_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_title("Other change validation request #19 - Back-Office Planning System")
    end
  end

  context "when state is closed" do
    before do
      stub_get_other_change_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 19,
            state: "closed",
            response: "I accept the change"
          },
        status: 200
      )
    end

    it "can't view edit action" do
      visit "/other_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "view the page for a closed other validation request" do
      visit "/other_change_validation_requests/19?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("My response to this request")
      expect(page).to have_content("I accept the change")
    end
  end

  context "when state is cancelled" do
    before do
      stub_get_other_change_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 19,
            state: "cancelled",
            cancel_reason: "My mistake",
            cancelled_at: "2021-10-20T11:42:50.951+01:00"
          },
        status: 200
      )
    end

    it "displays a cancellation summary for a cancelled validation request" do
      visit "/other_change_validation_requests/19?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Cancelled other request to change your application"
      expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
      expect(page).to have_content "The officer gave the following reason for cancelling this request:"
      expect(page).to have_content "My mistake"
      expect(page).to have_content "20 October 2021"
      expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
    end
  end

  context "when an officer adds a link in the suggestion/reason fields" do
    before do
      stub_get_other_change_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 19,
            state: "open",
            reason: "Details are on https://www.bops.co.uk/info",
            suggestion: "View to see <a href='https://www.bops.co.uk/payment'>Payment info</a>",
            response_due: "2022-7-1"
          },
        status: 200
      )
    end

    it "displays the link and link html as clickable" do
      visit "/other_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_link(
        "https://www.bops.co.uk/info",
        href: "https://www.bops.co.uk/info"
      )

      expect(page).to have_link(
        "Payment info",
        href: "https://www.bops.co.uk/payment"
      )
    end
  end
end
