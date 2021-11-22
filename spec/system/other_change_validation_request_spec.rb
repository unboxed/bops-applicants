require "rails_helper"

RSpec.describe "Other change requests", type: :system do
  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
  end

  it "allows the user to provide a response" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/other_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content("You applied for the wrong sort of certificate")
    expect(page).to have_content("Please confirm you want a Lawful Development certificate")

    fill_in "Respond to this request", with: "Agreed"

    change_request_patch_request = stub_request(:patch, "https://default.bops-care.link/api/v1/planning_applications/28/other_change_validation_requests/19?change_access_id=345443543")
        .with(
          body: { data: { response: "Agreed" } }.to_json,
          headers: headers,
        ).to_return(status: 200, body: "{}")

    click_button "Submit"

    expect(change_request_patch_request).to have_been_requested
    expect(page).to have_content("Your response was updated successfully")

    click_link("Other request", match: :first)

    expect(page).to have_content("The wrong fee has been paid")
    expect(page).to have_content("You need to pay an extra £100")
    expect(page).to have_content("I disagree with the extra fee ")
  end

  it "does not allow the user to submit a blank response", js: true do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/other_change_validation_requests/19/edit?change_access_id=345443543&planning_application_id=28"

    click_button "Submit"
    within(".govuk-error-summary") do
      expect(page).to have_content "Please enter your response to the planning officer's question."
    end
  end

  it "displays a cancellation summary for a cancelled validation request" do
    stub_cancelled_change_requests
    stub_successful_get_planning_application

    visit "/other_change_validation_requests/4?change_access_id=345443543&planning_application_id=28"

    expect(page).to have_content "Cancelled other request to change your application"
    expect(page).to have_content "This request has been cancelled. You do not have to take any further actions."
    expect(page).to have_content "The officer gave the following reason for cancelling this request:"
    expect(page).to have_content "My mistake"
    expect(page).to have_content "20 October 2021"
    expect(page).to have_link "Back", href: "/validation_requests?change_access_id=345443543&planning_application_id=28"
  end
end
