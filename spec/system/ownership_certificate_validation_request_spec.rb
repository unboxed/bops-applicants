# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Ownership certificate requests", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"

    stub_successful_get_planning_application
    stub_successful_get_local_authority
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
    it "allows the user to provide to disagree" do
      stub_successful_get_change_requests

      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content("Confirm ownership")
      expect(page).to have_content("You applied for the wrong sort of certificate")

      within_fieldset("Do you agree with this statement from the case officer?") do
        choose "No, I don't agree"
      end

      fill_in "Tell us why you don't agree. Include any information that will help the case officer understand your reasons.",
        with: "You got it wrong"

      stub_patch_rejected_ownership_certificate_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        rejection_reason: "You got it wrong",
        status: 200
      )

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
        expect(page).to have_content "Select an option"
      end
    end

    it "allows user to provide a response when they do know the owners" do
      stub_successful_get_change_requests

      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      choose "Yes, I agree"

      stub_successful_get_change_requests
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

      click_button "Submit"

      # Check errors
      click_button "Continue"

      expect(page).to have_content "Certificate type can't be blank"

      within_fieldset("Do you know how many owners there are?") do
        choose "Yes"
      end
      fill_in "How many owners are there", with: "2"
      within_fieldset("Do you know who the owners of the property are") do
        choose "Yes"
      end
      within_fieldset("Have you notified the owners of the land about this application?") do
        choose "Yes, all of them"
      end

      click_button "Continue"

      expect(page).to have_content "You must notify other owners about the proposed work"
      expect(page).to have_content "Add details of other owners"

      click_link "Add another owner"

      expect(page).to have_content "Details of owner"

      # Check errors
      click_button "Add owner"

      expect(page).to have_content "Name can't be blank"

      fill_in "Owner name", with: "Tom"
      fill_in "Address line 1", with: "Flat 1"
      fill_in "Address line 2 (optional)", with: "23 Street"
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
        expect(page).to have_content "01/02/2023"
      end

      click_link "Add another owner"

      fill_in "Owner name", with: "Bob"
      fill_in "Address line 1", with: "Flat 2"
      fill_in "Address line 2 (optional)", with: "24 Street"
      fill_in "Town", with: "London"
      fill_in "Postcode", with: "E16LT"

      click_button "Add owner"

      row = row_with_content("Bob")
      within(row) do
        expect(page).to have_content "Bob"
        expect(page).to have_content "No"
      end

      stub_successful_get_change_requests

      stub_patch_approved_ownership_certificate_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        status: 200,
        params: {
          certificate_type: "b",
          land_owners_attributes: [
            {
              name: "Tom",
              address_1: "Flat 1",
              address_2: "23 Street",
              town: "London",
              country: "",
              postcode: "E16LT",
              notice_given_at: "2023-02-01T00:00:00.000Z"
            },
            {
              name: "Bob",
              address_1: "Flat 2",
              address_2: "24 Street",
              town: "London",
              country: "",
              postcode: "E16LT",
              notice_given_at: nil
            }
          ]
        }
      )

      click_link "Accept and send"

      expect(page).to have_content "Thank you for confirming ownership"
    end

    it "allows user to provide a response when they don't know the owners" do
      visit "/ownership_certificate_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      within_fieldset("Do you agree with this statement from the case officer?") do
        choose "Yes, I agree"
      end

      stub_successful_get_change_requests

      click_button "Submit"

      within_fieldset("Do you know how many owners there are?") do
        choose "No"
      end
      within_fieldset("Do you know who the owners of the property are?") do
        choose "I don't know who they are"
      end
      within_fieldset("Have you notified the owners of the land about this application?") do
        choose "No"
      end

      click_button "Continue"

      expect(page).to have_content "You've told us that you don't know who any of the owners are"
      expect(page).not_to have_content "Add another owner"

      stub_successful_get_change_requests
      stub_patch_approved_ownership_certificate_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        status: 200,
        params: {
          certificate_type: "d",
          land_owners_attributes: []
        }
      )

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
end
