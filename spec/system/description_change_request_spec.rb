require "rails_helper"

RSpec.describe "Description change requests", type: :system do
  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
  end

  it "allows the user to accept a change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/description_change_requests/18/edit?change_access_id=345443543&planning_application_id=28"

    choose "Yes, I agree with the changes made"
    change_request_patch_request = stub_request(:patch, "https://default.lvh.me:3000/api/v1/planning_applications/28/description_change_requests/18?change_access_id=345443543")
    .with(
      body: "data%5Bapproved%5D=true",
      headers: headers,
    )
    .to_return(status: 200, body: "", headers: {})

    click_button "Submit"

    expect(change_request_patch_request).to have_been_requested
    expect(page).to have_content("Change request successfully updated.")
  end

  it "allows the user to reject a change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/description_change_requests/22/edit?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("Do you agree with the changes made to your application description?")
    choose "No, I disagree with the changes made"
    fill_in "Please indicate why you disagree with the changes and provide your suggested wording for the description.", with: "I wish to build a roman theatre"

    change_request_patch_request = stub_request(:patch, "https://default.lvh.me:3000/api/v1/planning_applications/28/description_change_requests/22?change_access_id=345443543")
    .with(
      body: "data%5Bapproved%5D=false&data%5Brejection_reason%5D=I%20wish%20to%20build%20a%20roman%20theatre",
      headers: headers,
    )
      .to_return(status: 200, body: "", headers: {})

    click_button "Submit"

    expect(change_request_patch_request).to have_been_requested
    stub_successful_get_planning_application

    stub_request(:get, "https://default.lvh.me:3000/api/v1/planning_applications/28/change_requests?change_access_id=345443543")
    .with(headers: headers)
    .to_return(status: 200, body: file_fixture("rejected_request.json").read, headers: {})
  end

  it "does not allow the user to reject a change request without filling in a rejection reason" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/description_change_requests/22/edit?change_access_id=345443543&planning_application_id=28"

    choose "No, I disagree with the changes made"

    click_button "Submit"
    expect(page).to have_content "Please fill in the reason for disagreeing with the suggested change."
  end

  it "displays the correct label for an accepted description change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/description_change_requests/19?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("Agreed with suggested changes")
  end

  it "displays the correct label for a rejected description change request" do
    stub_successful_get_planning_application
    stub_rejected_patch_with_reason

    visit "/description_change_requests/22?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("Disagreed with suggested changes")
    expect(page).to have_content("My objection and suggested wording for description:")
    expect(page).to have_content("I wish to build a roman theatre.")
  end
end
