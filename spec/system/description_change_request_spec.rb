require "rails_helper"

RSpec.describe "Description change requests", type: :system do
  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"

    stub_successful_get_planning_application
    stub_get_description_change_validation_request(
      id: 22,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          "id": 22,
          "state": "open",
        },
      status: 200,
    )
  end

  context "when state is open" do
    context "accepting change request" do
      before do
        stub_patch_approved_description_change_validation_request(
          id: 22,
          planning_id: 28,
          change_access_id: 345_443_543,
          status: 200,
        )
      end

      it "allows the user to accept a change request" do
        visit "/description_change_validation_requests/22/edit?change_access_id=345443543&planning_application_id=28"

        choose "Yes, I agree with the changes made"

        stub_successful_get_change_requests
        click_button "Submit"

        expect(page).to have_content("Your response was updated successfully")
      end

      it "has the correct page title" do
        visit "/description_change_validation_requests/22/edit?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_title("Description change validation request #22 - Back-Office Planning System")
      end
    end

    context "rejecting change request" do
      before do
        stub_patch_rejected_description_change_validation_request(
          id: 22,
          planning_id: 28,
          change_access_id: 345_443_543,
          rejection_reason: "I wish to build a roman theatre",
          status: 200,
        )
      end

      it "allows the user to reject a change request" do
        visit "/description_change_validation_requests/22/edit?change_access_id=345443543&planning_application_id=28"

        expect(page).to have_content("Do you agree with the changes made to your application description?")
        choose "No, I disagree with the changes made"
        fill_in "Please indicate why you disagree with the changes and provide your suggested wording for the description.", with: "I wish to build a roman theatre"

        stub_successful_get_change_requests
        click_button "Submit"

        expect(page).to have_content("Your response was updated successfully")
      end
    end

    context "when there are validation errors" do
      it "display an error if an option has not been selected" do
        visit "/description_change_validation_requests/22/edit?change_access_id=345443543&planning_application_id=28"

        click_button "Submit"
        within(".govuk-error-summary") do
          expect(page).to have_content "Please select an option"
        end
      end

      it "does not allow the user to reject a change request without filling in a rejection reason" do
        visit "/description_change_validation_requests/22/edit?change_access_id=345443543&planning_application_id=28"

        choose "No, I disagree with the changes made"

        click_button "Submit"
        within(".govuk-error-summary") do
          expect(page).to have_content "Please fill in the reason for disagreeing with the suggested change."
        end
      end
    end
  end

  it "displays the correct label for an accepted description change request" do
    stub_get_description_change_validation_request(
      id: 22,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          "id": 22,
          "state": "closed",
          "approved": true,

        },
      status: 200,
    )

    visit "/description_change_validation_requests/22?change_access_id=345443543&planning_application_id=28"
    expect(page).to have_content("Agreed with suggested changes")
  end

  context "when state is closed" do
    before do
      stub_get_description_change_validation_request(
        id: 22,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            "id": 22,
            "state": "closed",
            "proposed_description": "I wish to build a roman theatre.",
            "approved": false,
          },
        status: 200,
      )
    end

    it "displays the correct label for a rejected description change request" do
      visit "/description_change_validation_requests/22?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content("Disagreed with suggested changes")
      expect(page).to have_content("My objection and suggested wording for description:")
      expect(page).to have_content("I wish to build a roman theatre.")
    end

    it "can't view edit action if state is closed" do
      visit "/description_change_validation_requests/22/edit?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end
  end

  context "when state is cancelled" do
    before do
      stub_get_description_change_validation_request(
        id: 22,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            "id": 22,
            "state": "cancelled",
            "cancel_reason": "My mistake",
            "cancelled_at": "2021-10-20T11:42:50.951+01:00",
          },
        status: 200,
      )
    end

    it "displays a cancellation summary for a cancelled validation request" do
      visit "/description_change_validation_requests/22?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Cancelled request for changes to your description"
      expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
      expect(page).to have_content "The officer gave the following reason for cancelling this request:"
      expect(page).to have_content "My mistake"
      expect(page).to have_content "20 October 2021"
      expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
    end
  end
end
