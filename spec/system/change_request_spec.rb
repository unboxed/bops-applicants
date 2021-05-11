require "rails_helper"

RSpec.describe "Change requests", type: :system do
  before do
    ENV["API_BEARER"] = "123"
  end

  it "allows the user to see change requests associated with their application" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/change_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_content("Confirm changes to your application description")
    expect(page).to have_content("Description")
    expect(page).to have_content("Not started")
  end

  it "forbids the user from accessing change requests for a different application" do
    stub_request(:get, "http://default.lvh.me:3000/api/v1/planning_applications/28/change_requests?change_access_id=345443543")
    .to_return(status: 401)
    stub_successful_get_planning_application

    visit "/change_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_content("Forbidden")
  end

  it "displays the necessary information about the planning application associated with the change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/change_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_content("11 Mel Gardens, London, SE16 3RQ")
    expect(page).to have_content("Date received: 23 April 2021")
    expect(page).to have_content("00000028")
  end

  it "displays the due date of the latest change request in the index page" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/change_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_content("If requested changes are not received within 15 working days, by 25 May 2021")
  end

  it "displays the description of the change request on the change request page" do
    stub_successful_get_individual_change_request
    stub_successful_get_planning_application

    visit "/change_requests?planning_application_id=28&change_access_id=345443543"
    click_link "Description"

    expect(page).to have_content("This is a better description")
  end
end