# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Other change requests", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"

    stub_successful_get_planning_application
    stub_get_fee_change_validation_request(
      id: 19,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          id: 19,
          state: "open",
          reason: "I need evidence for the fee exemption",
          suggestion: "Please upload evidence",
          response_due: "2022-7-1"
        },
      status: 200
    )
  end

  context "when state is open" do
    before do
      stub_patch_fee_change_validation_request(
        id: 19,
        planning_id: 28,
        change_access_id: 345_443_543,
        response: "I have evidence",
        status: 200
      )
    end

    it "allows the user to provide a response" do
      visit "/fee_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      within(".govuk-list") do
        expect(page).to have_content("read the comment from the case officer")
        expect(page).to have_content("upload supporting documents if requested")
        expect(page).to have_content("if you don't agree with what the case officer has said, add a comment to explain why you don't agree")
      end

      expect(page).to have_content(
        "Send your response by 1 July 2022. If we don't receive your response by this date, we will return your application to you and refund your payment."
      )

      expect(page).to have_content("Comment from case officer")
      expect(page).to have_content("The case officer gave this reason why the fee is currently invalid:")
      expect(page).to have_content("I need evidence for the fee exemption")

      expect(page).to have_content("How to make your application valid")
      expect(page).to have_content("The case officer has asked you to:")
      expect(page).to have_content("Please upload evidence")

      fill_in "fee-change-validation-request-response-field", with: "I have evidence"
      attach_file("Upload documents", "spec/fixtures/images/proposed-floorplan.png")
    end

    it "can't view show action" do
      visit "/fee_change_validation_requests/19?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "does not allow the user to submit a blank response" do
      visit "/fee_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      click_button "Submit"
      within(".govuk-error-summary") do
        expect(page).to have_content "Please enter your response to the planning officer's question."
      end
    end

    it "has the correct page title" do
      visit "/fee_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_title("Fee change validation request #19 - Back-Office Planning System")
    end
  end

  context "when state is closed" do
    before do
      stub_get_fee_change_validation_request(
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
      visit "/fee_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "view the page for a closed fee change validation request" do
      visit "/fee_change_validation_requests/19?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("My response to this request")
      expect(page).to have_content("I accept the change")
    end
  end

  context "when state is cancelled" do
    before do
      stub_get_fee_change_validation_request(
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
      visit "/fee_change_validation_requests/19?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Cancelled fee change request on your application"
      expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
      expect(page).to have_content "The officer gave the following reason for cancelling this request:"
      expect(page).to have_content "My mistake"
      expect(page).to have_content "20 October 2021"
      expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
    end
  end

  context "when an officer adds a link in the suggestion/summary fields" do
    before do
      stub_get_fee_change_validation_request(
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
      visit "/fee_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

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
