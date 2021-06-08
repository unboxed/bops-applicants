require "rails_helper"

RSpec.describe "Document change requests", type: :system do
  include ActionDispatch::TestProcess::FixtureFile

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
  end

  it "allows the user to view a document change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/document_change_requests/8/edit?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("Name of file on submission:")
    expect(page).to have_content("20210512_162911.jpg")
    expect(page).to have_content("Its a chicken coop not a floor plan.")
    expect(page).to have_content("Upload a replacement file")
  end

  it "allows the user to update a document change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/document_change_requests/8/edit?change_access_id=345443543&planning_application_id=28"

    attach_file("Upload a replacement file", "spec/fixtures/images/proposed-floorplan.png")
    change_request_patch_request = stub_request(:patch, "https://default.local.abscond.org/api/v1/planning_applications/28/document_change_requests/8?change_access_id=345443543")
    .to_return(status: 200, body: "", headers: {})

    click_button "Submit"
    expect(change_request_patch_request).to have_been_requested
    stub_successful_get_planning_application
  end

  it "displays the new document in the show page for a closed description change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/document_change_requests/12?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content "Name of file on submission:"
    expect(page).to have_content "paul-volkmer.jpg"
    expect(page).to have_content "Case officer's reason for requesting the document:"
    expect(page).to have_content "Its a galaxy."
    expect(page).to have_content "Document uploaded:"
    expect(page).to have_content "max-baskakov-catunsplash.jpg"
  end
end
