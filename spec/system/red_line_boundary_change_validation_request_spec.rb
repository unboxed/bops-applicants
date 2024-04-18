# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Red line boundary change requests", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"

    stub_successful_get_planning_application
    stub_successful_get_local_authority
    stub_get_red_line_boundary_change_validation_request(
      id: 10,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          id: 10,
          state: "open",
          new_geojson: "",
          reason: nil,
          approved: nil,
          response_due: "2022-7-1"
        },
      status: 200
    )
  end

  context "when state is open" do
    context "accepting change request" do
      before do
        stub_patch_approved_red_line_boundary_change_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          status: 200
        )
      end

      it "allows the user to accept a change request" do
        visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content(
          "If your response is not received by 1 July 2022 your application will be returned to you and your payment refunded."
        )

        choose "Yes, I agree with the proposed red line boundary"

        stub_successful_get_change_requests
        click_button "Submit"

        expect(page).to have_content("Your response has been sent to the case officer.")
      end

      it "has the correct page title" do
        visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_title("Red line boundary change validation request #10 - Back-Office Planning System")
      end
    end

    context "rejecting change request" do
      before do
        stub_patch_rejected_red_line_boundary_change_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          rejection_reason: "I think the boundary is wrong",
          status: 200
        )
      end

      it "allows the user to reject a change request" do
        visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content("Confirm changes to your application's red line boundary")
        choose "No, I disagree with the proposed red line boundary"
        fill_in "Please indicate why you disagree with the proposed red line boundary.", with: "I think the boundary is wrong"

        stub_successful_get_change_requests
        click_button "Submit"

        expect(page).to have_content("Your response has been sent to the case officer.")
      end

      it "does not allow the user to reject a change request without filling in a rejection reason" do
        visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

        choose "No, I disagree with the proposed red line boundary"

        click_button "Submit"
        within(".govuk-error-summary") do
          expect(page).to have_content "Indicate why you disagree with the proposed red line boundary."
        end
      end
    end

    it "display an error if an option has not been selected" do
      visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

      click_button "Submit"
      within(".govuk-error-summary") do
        expect(page).to have_content "Select an option"
      end
    end

    it "can't view show action" do
      visit "/red_line_boundary_change_validation_requests/10?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end
  end

  context "when state is closed" do
    context "when approved" do
      before do
        stub_get_red_line_boundary_change_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          response_body:
            {
              id: 10,
              state: "closed",
              approved: true
            },
          status: 200
        )
      end

      it "displays the correct label for an accepted boundary change request" do
        visit "/red_line_boundary_change_validation_requests/10?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content("Agreed with suggested boundary changes")
      end

      it "can't view edit action" do
        visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"
        expect(page).to have_content("Not Found")
      end
    end

    context "when not approved" do
      before do
        stub_get_red_line_boundary_change_validation_request(
          id: 10,
          planning_id: 28,
          change_access_id: 345_443_543,
          response_body:
            {
              id: 10,
              state: "closed",
              rejection_reason: "I do not agree with this boundary",
              approved: false
            },
          status: 200
        )
      end

      it "displays the correct label for a rejected boundary change request" do
        visit "/red_line_boundary_change_validation_requests/10?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content("Disagreed with suggested boundary changes")
        expect(page).to have_content("My reason for objecting to the boundary changes:")
        expect(page).to have_content("I do not agree with this boundary")
      end
    end
  end

  context "when state is cancelled" do
    before do
      stub_get_red_line_boundary_change_validation_request(
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
      visit "/red_line_boundary_change_validation_requests/10?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Cancelled request to change your application's red line boundary"
      expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
      expect(page).to have_content "The officer gave the following reason for cancelling this request:"
      expect(page).to have_content "My mistake"
      expect(page).to have_content "20 October 2021"
      expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
    end
  end

  context "when an officer adds a link to the reason" do
    before do
      stub_get_red_line_boundary_change_validation_request(
        id: 10,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 10,
            state: "open",
            new_geojson: "",
            reason: "Reason on https://www.bops.co.uk/reason",
            approved: nil,
            response_due: "2022-7-1"
          },
        status: 200
      )
    end

    it "displays the link and link html as clickable" do
      visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_link(
        "https://www.bops.co.uk/reason",
        href: "https://www.bops.co.uk/reason"
      )
    end
  end
end
