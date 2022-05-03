require "rails_helper"

RSpec.describe "Document create requests", type: :system do
  include ActionDispatch::TestProcess::FixtureFile

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"

    stub_successful_get_planning_application
    stub_get_additional_document_validation_request(
      id: 3,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          "id": 3,
          "state": "open",
          "document_request_type": "Roman theatre plan",
          "document_request_reason": "I do not see a vomitorium in this.",
        },
      status: 200,
    )
  end

  context "when state is open" do
    it "allows the user to view an open document create request" do
      visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"

      expect(page).to have_content("Document requested:")
      expect(page).to have_content("Roman theatre plan")
      expect(page).to have_content("Case officer's reason for requesting the document:")
      expect(page).to have_content("I do not see a vomitorium in this.")

      expect(page).to have_link(
        "Please ensure you have read how to correctly prepare plans (Opens in a new window or tab)",
        href: "#{ENV['PROTOCOL']}://default.#{ENV['API_HOST']}/planning_guides/index",
      )
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
        status: 200,
      )
    end

    it "allows the user to update a document create request" do
      visit "/additional_document_validation_requests/3/edit?change_access_id=345443543&planning_application_id=28"

      attach_file("Upload new file(s)", "spec/fixtures/images/proposed-floorplan.png")

      click_button "Submit"
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
            "id": 3,
            "state": "closed",
            "document_request_type": "Floor plan",
            "document_request_reason": "No floor plan.",
            "documents": [
              {
                "name": "proposed-floorplan.jpg",
                "url": "http://southwark.bops-care.link:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBkdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c9f482b79792231cade4fd9fe59c1b622dab5713/proposed-floorplan.png",
              },
              {
                "name": "proposed-floorplan-2.jpg",
                "url": "http://southwark.bops-care.link:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBkdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c9f482b79792231cade4fd9fe59c1b622dab5713/proposed-floorplan-2.png",
              },
            ],
          },
        status: 200,
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
            "id": 3,
            "state": "cancelled",
            "cancel_reason": "My mistake",
            "cancelled_at": "2021-10-20T11:42:50.951+01:00",
          },
        status: 200,
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
end
