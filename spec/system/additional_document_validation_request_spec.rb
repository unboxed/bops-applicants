# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Document create requests", type: :system do
  include_context "local_authority_contact_details"
  include ActionDispatch::TestProcess::FixtureFile

  let(:response_body) do
    {
      id: 3,
      state: "open",
      document_request_type: "Roman theatre plan",
      document_request_reason: "I do not see a vomitorium in this.",
      response_due: "2022-7-1",
      post_validation: false
    }.stringify_keys
  end

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"

    stub_successful_get_planning_application
    stub_get_additional_document_validation_request(
      id: 3,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:,
      status: 200
    )
  end

  context "when state is open" do
    it "allows the user to view an open document create request" do
      visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content("Select 'choose files' and upload a file or multiple files from your device")
      expect(page).to have_content("The file(s) must be smaller than 30MB")
      expect(page).to have_content("Click save or open to add the file")
      expect(page).to have_content("Click submit to complete this action")

      expect(page).to have_content(
        "If your response is not received by 1 July 2022 your application will be returned to you and your payment refunded."
      )

      expect(page).to have_content("Document requested:")
      expect(page).to have_content("Roman theatre plan")
      expect(page).to have_content("Case officer's reason for requesting the document:")
      expect(page).to have_content("I do not see a vomitorium in this.")

      expect(page).to have_link(
        "Please ensure you have read how to correctly prepare plans (Opens in a new window or tab)",
        href: "#{Rails.configuration.api_protocol}://default.#{Rails.configuration.api_host}/planning_guides/index"
      )
    end

    context "when request is post validation" do
      let(:response_body) do
        {
          id: 3,
          state: "open",
          document_request_type: "Roman theatre plan",
          document_request_reason: "No room for the lions",
          response_due: "2022-7-1",
          post_validation: true
        }.stringify_keys
      end

      it "does not display return and refund information" do
        visit edit_additional_document_validation_request_path(
          3,
          planning_application_id: 28,
          change_access_id: "345443543"
        )

        expect(page).not_to have_content(
          "If your response is not received by 1 July 2022 your application will be returned to you and your payment refunded."
        )
      end
    end

    it "can't view show action" do
      visit "/additional_document_validation_requests/3?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end

    it "has the correct page title" do
      visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_title("Additional document validation request #3 - Back-Office Planning System")
    end
  end

  context "Adding a document" do
    before do
      stub_patch_additional_documents_validation_request(
        id: 3,
        planning_id: 28,
        change_access_id: 345_443_543,
        status: 200
      )
    end

    it "allows the user to update a document create request" do
      visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"

      attach_file("Upload new file(s)", "spec/fixtures/images/proposed-floorplan.png")

      click_button "Submit"
    end

    context "when a file exceeding 30mb has been submitted" do
      before do
        stub_patch_additional_documents_validation_request(
          id: 3,
          planning_id: 28,
          change_access_id: 345_443_543,
          status: 413,
          body: "The file: 'proposed-floorplan.png' exceeds the limit of 30mb. Each file must be 30MB or less"
        )
      end

      it "returns an error to the user" do
        visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"

        attach_file("Upload new file(s)", "spec/fixtures/images/proposed-floorplan.png")

        click_button "Submit"

        within(".govuk-error-summary") do
          expect(page).to have_content("There is a problem")
          expect(page).to have_content("The file: 'proposed-floorplan.png' exceeds the limit of 30mb. Each file must be 30MB or less")
        end

        within(".govuk-error-message") do
          expect(page).to have_content("The file: 'proposed-floorplan.png' exceeds the limit of 30mb. Each file must be 30MB or less")
        end

        expect(page).to have_current_path("/additional_document_validation_requests/3?change_access_id=345443543&planning_application_id=28")
      end
    end
  end

  context "when state is closed" do
    before do
      stub_get_additional_document_validation_request(
        id: 3,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 3,
            state: "closed",
            document_request_type: "Floor plan",
            document_request_reason: "No floor plan.",
            documents: [
              {
                name: "proposed-floorplan.jpg",
                url: "http://southwark.bops.test/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBkdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c9f482b79792231cade4fd9fe59c1b622dab5713/proposed-floorplan.png"
              },
              {
                name: "proposed-floorplan-2.jpg",
                url: "http://southwark.bops.test/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBkdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c9f482b79792231cade4fd9fe59c1b622dab5713/proposed-floorplan-2.png"
              }
            ]
          },
        status: 200
      )
    end

    it "displays the new document in the show page for a closed document create request" do
      visit "/additional_document_validation_requests/3?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Document requested:"
      expect(page).to have_content "Floor plan"
      expect(page).to have_content "Case officer's reason for requesting the document:"
      expect(page).to have_content "No floor plan"
      expect(page).to have_content "proposed-floorplan.jpg"
      expect(page).to have_content "proposed-floorplan-2.jpg"
    end

    it "can't view edit action" do
      visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"
      expect(page).to have_content("Not Found")
    end
  end

  context "when state is cancelled" do
    before do
      stub_get_additional_document_validation_request(
        id: 3,
        planning_id: 28,
        change_access_id: 345_443_543,
        response_body:
          {
            id: 3,
            state: "cancelled",
            cancel_reason: "My mistake",
            cancelled_at: "2021-10-20T11:42:50.951+01:00"
          },
        status: 200
      )
    end

    it "displays a cancellation summary for a cancelled validation request" do
      visit "/additional_document_validation_requests/3?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content "Cancelled request to provide a new document"
      expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
      expect(page).to have_content "The officer gave the following reason for cancelling this request:"
      expect(page).to have_content "My mistake"
      expect(page).to have_content "20 October 2021"
      expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
    end
  end

  context "when an officer adds a link to the request type and reason" do
    let(:response_body) do
      {
        id: 3,
        state: "open",
        document_request_type: "Link to https://www.bops.co.uk/type",
        document_request_reason: "View reason <a href='https://www.bops.co.uk/reason'>Request reason</a>",
        response_due: "2022-7-1",
        post_validation: false
      }.stringify_keys
    end

    it "displays the link and link html as clickable" do
      visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_link(
        "https://www.bops.co.uk/type",
        href: "https://www.bops.co.uk/type"
      )

      expect(page).to have_link(
        "Request reason",
        href: "https://www.bops.co.uk/reason"
      )
    end
  end
end
