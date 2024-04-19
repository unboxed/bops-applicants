# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pre-commencement condition validation requests", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"

    stub_successful_get_planning_application
    stub_get_pre_commencement_condition_validation_request(
      id: 10,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          id: 10,
          state: "open",
          reason: nil,
          approved: nil,
          response_due: "2022-7-1",
          condition: {
            title: "First condition"
          }
        },
      status: 200
    )
  end

  context "when state is open" do
    context "accepting change request" do
      before do
        stub_patch_approved_pre_commencement_condition_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          status: 200
        )
      end

      it "allows the user to accept a change request" do
        visit "/pre_commencement_condition_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content(
          "If you do not submit a response by 1 July 2022, the pre-commencement conditions will be automatically accepted for use within your application."
        )

        choose "Accept"

        stub_successful_get_change_requests
        click_button "Submit"

        expect(page).to have_content("Your response has been sent to the case officer.")
      end
    end

    context "rejecting change request" do
      before do
        stub_patch_rejected_pre_commencement_condition_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          rejection_reason: "I think this is wrong",
          status: 200
        )
      end

      it "allows the user to reject a change request" do
        visit "/pre_commencement_condition_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content("Review pre-commencement condition")
        choose "Not accept"
        fill_in "Tell the case officer why you do not accept this condition", with: "I think this is wrong"

        stub_successful_get_change_requests
        click_button "Submit"

        expect(page).to have_content("Your response has been sent to the case officer.")
      end

      it "does not allow the user to reject a change request without filling in a rejection reason" do
        visit "/pre_commencement_condition_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

        choose "Not accept"

        click_button "Submit"
        within(".govuk-error-summary") do
          expect(page).to have_content "Fill in why you disagree with the proposed pre-commencement condition."
        end
      end
    end

    it "display an error if an option has not been selected" do
      visit "/pre_commencement_condition_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

      click_button "Submit"

      within(".govuk-error-summary") do
        expect(page).to have_content "Select an option"
      end
    end

    it "can't view show action" do
      visit "/pre_commencement_condition_validation_requests/10?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end
  end

  context "when state is closed" do
    context "when approved" do
      before do
        stub_successful_get_planning_application
        stub_get_pre_commencement_condition_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          response_body:
            {
              id: 10,
              state: "closed",
              approved: true,
              response_due: "2022-7-1",
              condition: {
                title: "My condition"
              }
            },
          status: 200
        )
      end

      it "displays the correct label for an accepted boundary change request" do
        visit "/pre_commencement_condition_validation_requests/10?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content("Agreed to the condition")
      end

      it "can't view edit action" do
        visit "/pre_commencement_condition_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"
        expect(page).to have_content("Not Found")
      end
    end

    context "when not approved" do
      before do
        stub_successful_get_planning_application
        stub_get_pre_commencement_condition_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          response_body:
            {
              id: 10,
              state: "closed",
              rejection_reason: "I do not agree with this",
              approved: false,
              response_due: "2022-7-1",
              condition: {
                title: "Bad condition"
              }
            },
          status: 200
        )
      end

      it "displays the correct label for a rejected boundary change request" do
        visit "/pre_commencement_condition_validation_requests/10?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content("Disagreed with the condition")
        expect(page).to have_content("My reason for disagreeing:")
        expect(page).to have_content("I do not agree")
      end
    end
  end

  context "when state is cancelled" do
    before do
      stub_successful_get_planning_application
      stub_get_pre_commencement_condition_validation_request(
        id: 10,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 10,
            state: "cancelled",
            cancel_reason: "My mistake",
            cancelled_at: "2021-10-20T11:42:50.951+01:00"
          },
        status: 200
      )
    end

    it "displays a cancellation summary for a cancelled validation request" do
      visit "/pre_commencement_condition_validation_requests/10?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Cancelled pre-commencement condition request for your application"
      expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
      expect(page).to have_content "The officer gave the following reason for cancelling this request:"
      expect(page).to have_content "My mistake"
      expect(page).to have_content "20 October 2021"
      expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
    end
  end
end
