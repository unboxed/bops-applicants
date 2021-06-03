require "rails_helper"

RSpec.describe "Red line boundary change requests", type: :system do
  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
  end

  it "allows the user to accept a change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/red_line_boundary_change_requests/18/edit?change_access_id=345443543&planning_application_id=28"

    choose "Yes, I agree with the proposed red line boundary"
    change_request_patch_request = stub_request(:patch, "https://default.lvh.me:3000/api/v1/planning_applications/28/red_line_boundary_change_requests/2?change_access_id=345443543")
                                       .with(
                                           body: "data%5Bapproved%5D=true",
                                           headers: headers,
                                           )
                                       .to_return(status: 200, body: "", headers: {})

    click_button "Submit"

    expect(change_request_patch_request).to have_been_requested
    expect(page).to have_content("Change request successfully updated.")
  end
end
