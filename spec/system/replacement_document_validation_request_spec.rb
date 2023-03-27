# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Document change requests", type: :system do
  include_context "local_authority_contact_details"
  include ActionDispatch::TestProcess::FixtureFile

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"

    stub_successful_get_planning_application
    stub_get_replacement_document_validation_request(
      id: 8,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          id: 8,
          state: "open",
          old_document: {
            name: "20210512_162911.jpg",
            invalid_document_reason: "Its a chicken coop not a floor plan."
          },
          response_due: "2022-7-1"
        },
      status: 200
    )
  end

  context "when state is open" do
    before do
      stub_patch_replacement_document_validation_request(
        id: 8,
        planning_id: 28,
        change_access_id: 345_443_543,
        status: 200
      )
    end

    it "allows the user to view a document change request" do
      visit "/replacement_document_validation_requests/8/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content("Select 'choose file' and upload a replacement file from your device")
      expect(page).to have_content("The file must be smaller than 30MB")
      expect(page).to have_content("Click save or open to add the file")
      expect(page).to have_content("Click submit to complete this action")

      expect(page).to have_content(
        "If your response is not received by 1 July 2022 your application will be returned to you and your payment refunded."
      )

      expect(page).to have_content("Name of file on submission:")
      expect(page).to have_content("20210512_162911.jpg")
      expect(page).to have_content("Its a chicken coop not a floor plan.")
      expect(page).to have_content("Upload a replacement file")

      expect(page).to have_link(
        "Please ensure you have read how to correctly prepare plans (Opens in a new window or tab)",
        href: "#{ENV.fetch('PROTOCOL', nil)}://default.#{ENV.fetch('API_HOST', nil)}/planning_guides/index"
      )
    end

    it "allows the user to update a document change request" do
      visit "/replacement_document_validation_requests/8/edit?change_access_id=345443543&planning_application_id=28"

      attach_file("Upload a replacement file", "spec/fixtures/images/proposed-floorplan.png")

      click_button "Submit"
    end

    it "can't view show action" do
      visit "/replacement_document_validation_requests/8?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "has the correct page title" do
      visit "/replacement_document_validation_requests/8/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_title("Replacement document validation request #8 - Back-Office Planning System")
    end

    it "returns an error to the user when no file is submitted" do
      visit "/replacement_document_validation_requests/8/edit?change_access_id=345443543&planning_application_id=28"

      click_button "Submit"

      within(".govuk-error-summary") do
        expect(page).to have_content("There is a problem")
        expect(page).to have_content("Please choose a file to upload")
      end

      within(".govuk-error-message") do
        expect(page).to have_content("Please choose a file to upload")
      end

      expect(page).to have_current_path("/replacement_document_validation_requests/8?change_access_id=345443543&planning_application_id=28")
    end

    context "when a file exceeding 30mb has been submitted" do
      before do
        stub_patch_replacement_document_validation_request(
          id: 8,
          planning_id: 28,
          change_access_id: 345_443_543,
          status: 413,
          body: "The file must be smaller than 30MB"
        )
      end

      it "return an error to the user" do
        visit "/replacement_document_validation_requests/8/edit?change_access_id=345443543&planning_application_id=28"

        attach_file("Upload a replacement file", "spec/fixtures/images/proposed-floorplan.png")

        click_button "Submit"

        within(".govuk-error-summary") do
          expect(page).to have_content("There is a problem")
          expect(page).to have_content("The file must be smaller than 30MB")
        end

        within(".govuk-error-message") do
          expect(page).to have_content("The file must be smaller than 30MB")
        end

        expect(page).to have_current_path("/replacement_document_validation_requests/8?change_access_id=345443543&planning_application_id=28")
      end
    end
  end

  context "when state is closed" do
    before do
      stub_get_replacement_document_validation_request(
        id: 8,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 8,
            state: "closed",
            old_document: {
              name: "paul-volkmer.jpg",
              invalid_document_reason: "Its a galaxy."
            },
            new_document: {
              name: "max-baskakov-catunsplash.jpg",
              url: "http://southwark.bops-care.link:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBRZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--772d855213ddd9220ca829cec75caaafe68a3fc8/max-baskakov-catunsplash.jpg"
            }
          },
        status: 200
      )
    end

    it "displays the new document in the show page for a closed description change request" do
      visit "/replacement_document_validation_requests/8?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Name of file on submission:"
      expect(page).to have_content "paul-volkmer.jpg"
      expect(page).to have_content "Case officer's reason for requesting the document:"
      expect(page).to have_content "Its a galaxy."
      expect(page).to have_content "Document uploaded:"
      expect(page).to have_content "max-baskakov-catunsplash.jpg"
    end

    it "can't view edit action" do
      visit "/replacement_document_validation_requests/8/edit?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end
  end

  context "when state is cancelled" do
    before do
      stub_get_replacement_document_validation_request(
        id: 8,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 8,
            state: "cancelled",
            cancel_reason: "My mistake",
            cancelled_at: "2021-10-20T11:42:50.951+01:00"
          },
        status: 200
      )
    end

    it "displays a cancellation summary for a cancelled validation request" do
      stub_cancelled_change_requests
      stub_successful_get_planning_application

      visit "/replacement_document_validation_requests/8?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Cancelled request to provide a replacement document"
      expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
      expect(page).to have_content "The officer gave the following reason for cancelling this request:"
      expect(page).to have_content "My mistake"
      expect(page).to have_content "20 October 2021"
      expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
    end
  end

  context "when an officer adds a link to the invalid document reason" do
    before do
      stub_get_replacement_document_validation_request(
        id: 8,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 8,
            state: "open",
            old_document: {
              name: "20210512_162911.jpg",
              invalid_document_reason: "Invalid reason can be found on https://www.bops.co.uk/invalid_document_reason"
            },
            response_due: "2022-7-1"
          },
        status: 200
      )
    end

    it "displays the link and link html as clickable" do
      visit "/replacement_document_validation_requests/8/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_link(
        "https://www.bops.co.uk/invalid_document_reason",
        href: "https://www.bops.co.uk/invalid_document_reason"
      )
    end
  end
end
