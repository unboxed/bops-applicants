require "rails_helper"

RSpec.describe "Description change requests", type: :system do
  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
  end

  it "allows the user to accept a change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

    choose "Yes, I agree with the proposed red line boundary"
    change_request_patch_request = stub_request(:patch, "https://default.bops-care.link/api/v1/planning_applications/28/red_line_boundary_change_validation_requests/10?change_access_id=345443543")
                                       .with(
                                         body: { data: { approved: true } }.to_json,
                                         headers: headers,
                                       )
                                       .to_return(status: 200, body: "{}")

    click_button "Submit"

    expect(change_request_patch_request).to have_been_requested
    expect(page).to have_content("Your response was updated successfully")
  end

  it "allows the user to reject a change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("Confirm changes to your application's red line boundary")
    choose "No, I disagree with the proposed red line boundary"
    fill_in "Please indicate why you disagree with the proposed red line boundary.", with: "I think the boundary is wrong"

    change_request_patch_request = stub_request(:patch, "https://default.bops-care.link/api/v1/planning_applications/28/red_line_boundary_change_validation_requests/10?change_access_id=345443543")
        .with(
          body: { data: { approved: false, rejection_reason: "I think the boundary is wrong" } }.to_json,
          headers: headers,
        )
        .to_return(status: 200, body: "{}")

    click_button "Submit"
    expect(change_request_patch_request).to have_been_requested
    stub_successful_get_planning_application

    stub_request(:get, "https://default.bops-care.link/api/v1/planning_applications/28/validation_requests?change_access_id=345443543")
        .with(headers: headers)
        .to_return(status: 200, body: file_fixture("rejected_request.json").read, headers: {})
  end

  it "display an error if an option has not been selected" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

    click_button "Submit"
    within(".govuk-error-summary") do
      expect(page).to have_content "Please select an option"
    end
  end

  it "does not allow the user to reject a change request without filling in a rejection reason" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/red_line_boundary_change_validation_requests/10/edit?change_access_id=345443543&planning_application_id=28"

    choose "No, I disagree with the proposed red line boundary"

    click_button "Submit"
    within(".govuk-error-summary") do
      expect(page).to have_content "Please indicate why you disagree with the proposed red line boundary."
    end
  end

  it "displays the correct label for an accepted boundary change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/red_line_boundary_change_validation_requests/11?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("Agreed with suggested boundary changes")
  end

  it "displays the correct label for a rejected boundary change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application
    stub_rejected_patch_with_reason

    visit "/red_line_boundary_change_validation_requests/35?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("Disagreed with suggested boundary changes")
    expect(page).to have_content("My reason for objecting to the boundary changes:")
    expect(page).to have_content("I do not agree with this boundary")
  end

  it "displays a cancellation summary for a cancelled validation request" do
    stub_cancelled_change_requests
    stub_successful_get_planning_application

    visit "/red_line_boundary_change_validation_requests/10?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content "Cancelled request to change your application's red line boundary"
    expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
    expect(page).to have_content "The officer gave the following reason for cancelling this request:"
    expect(page).to have_content "My mistake"
    expect(page).to have_content "20 October 2021"
    expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
  end
end
