require "rails_helper"

RSpec.describe "Document create requests", type: :system do
  include ActionDispatch::TestProcess::FixtureFile

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
  end

  it "allows the user to view an open document create request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/document_create_requests/3/edit?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("File requested:")
    expect(page).to have_content("Roman theatre plan")
    expect(page).to have_content("The reason for the requested file:")
    expect(page).to have_content("I do not see a vomitorium in this.")
  end

  it "allows the user to update a document create request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/document_create_requests/3/edit?change_access_id=345443543&planning_application_id=28"

    attach_file("Upload a new file", "spec/fixtures/images/proposed-floorplan.png")
    change_request_patch_request = stub_request(:patch, "https://default.lvh.me:3000/api/v1/planning_applications/28/document_create_requests/3?change_access_id=345443543")
    .to_return(status: 200, body: "", headers: {})

    click_button "Submit"
    expect(change_request_patch_request).to have_been_requested
    stub_successful_get_planning_application
  end

  it "displays the new document in the show page for a closed document create request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/document_create_requests/4?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content "File requested:"
    expect(page).to have_content "Floor plan"
    expect(page).to have_content "The reason for the requested file:"
    expect(page).to have_content "No floor plan"
    expect(page).to have_content "proposed-floorplan.png"
  end
end
