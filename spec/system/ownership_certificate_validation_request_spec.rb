# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Ownership certificate requests", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"

    stub_successful_get_planning_application
    stub_get_ownership_certificate_validation_request(
      id: 19,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          id: 19,
          state: "open",
          reason: "You applied for the wrong sort of certificate",
          response_due: "2022-7-1"
        },
      status: 200
    )
  end

  context "when state is open" do
    before do
      stub_patch_ownership_certificate_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        response: "Agreed",
        status: 200
      )
    end

    it "allows the user to provide to disagree" do
      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content("Confirm ownership")
      expect(page).to have_content("You applied for the wrong sort of certificate")

      fill_in "Do you agree with this statement from the case officer?", with: "No, I don't agree"
      fill_in "Tell us why you don't agree. Include any information that will help the case officer understand your reasons.",
        with: "You got it wrong"

      stub_successful_get_change_requests
      click_button "Submit"

      expect(page).to have_content("Your response was updated successfully")
    end

    it "can't view show action" do
      visit "/ownership_certificate_validation_requests/19?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "does not allow the user to submit a blank response" do
      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      click_button "Submit"
      within(".govuk-error-summary") do
        expect(page).to have_content "Please enter your response to the planning officer's question."
      end
    end

    it "allows user to provide a response when they do know the owners" do
      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      fill_in "Do you agree with this statement from the case officer?", with: "Yes, I agree"

      click_button "Submit"

      # Check errors
      click_button "Continue"

      expect(page).to have_content "Certificate type can't be blank"

      fill_in "Do you know how many owners there are?", with: "Yes"
      fill_in "How many owners are there", with: "2"
      fill_in "Do you know who the owners of the property are", with: "Yes"
      fill_in "Have you notified the owners of the land about this application?", with: "Yes"

      click_button "Continue"

      expect(page).to have_content "You must notify other owners about the proposed work"
      expect(page).to have_content "Add details of other owners"

      click_button "Add another owner"

      expect(page).to have_content "Details of owner"

      # Check errors
      click_button "Add owner"

      expect(page).to have_content "Name can't be blank"

      fill_in "Owner name", with: "Tom"
      fill_in "Address line 1", with: "Flat 1"
      fill_in "Address line 2", with: "23 Street"
      fill_in "Town", with: "London"
      fill_in "Postcode", with: "E16LT"
      fill_in "Day", with: "1"
      fill_in "Month", with: "2"
      fill_in "Year", with: "2023"

      click_button "Add owner"

      row = row_with_content("Tom")
      within(row) do
        expect(page).to have_content "Tom"
        expect(page).to have_content "Yes"
        expect(page).to have_content "1/2/2023"
      end

      click_button "Add another owner"

      fill_in "Owner name", with: "Bob"
      fill_in "Address line 1", with: "Flat 2"
      fill_in "Address line 2", with: "24 Street"
      fill_in "Town", with: "London"
      fill_in "Postcode", with: "E16LT"

      click_button "Add owner"

      row = row_with_content("Tom")
      within(row) do
        expect(page).to have_content "Bob"
        expect(page).to have_content "No"
      end

      click_link "Accept and send"

      expect(page).to have_content "Thank you for confirming ownership"
    end

    it "allows user to provide a response when they don't know the owners" do
      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      fill_in "Do you agree with this statement from the case officer?", with: "Yes, I agree"

      click_button "Submit"

      fill_in "Do you know how many owners there are?", with: "No"
      fill_in "Do you know who the owners of the property are", with: "No"
      fill_in "Have you notified the owners of the land about this application?", with: "No"

      click_button "Continue"

      expect(page).to have_content "You've told us that you don't know who any of the owners are"
      expect(page).not_to have_content "Add another owner"

      click_link "Accept and send"

      expect(page).to have_content "Thank you for confirming ownership"
    end
  end

  context "when state is closed" do
    before do
      stub_get_ownership_certificate_validation_request(
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
      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "view the page for a closed other validation request" do
      visit "/ownership_certificate_validation_requests/19?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("My response to this request")
      expect(page).to have_content("I accept the change")
    end
  end

  context "when state is cancelled" do
    before do
      stub_get_ownership_certificate_validation_request(
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
      visit "/ownership_certificate_validation_requests/19?change_access_id=345443543&planning_application_id=28"

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
      stub_get_ownership_certificate_validation_request(
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
      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

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
