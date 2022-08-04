require "rails_helper"

RSpec.describe "Change requests", type: :system do
  let(:contact_details) do
    {
      default: {
        email_address: "planning@default.gov.uk",
        feedback_email: "planning@default.gov.uk",
        phone_number: "01234123123",
        postal_address: "Planning, 123 High Street, Big City, AB3 4EF",
        privacy_policy: "https://www.default.gov.uk/privacy-policy",
      },
    }.deep_stringify_keys
  end

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"

    allow(YAML).to receive(:load_file).and_call_original

    allow(YAML)
      .to receive(:load_file)
      .with(Rails.root.join("config/contact_details.yml"))
      .and_return(contact_details)
  end

  it "allows the user to see change requests associated with their application" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/validation_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_content("Confirm changes to your application description")
    expect(page).to have_content("Description")
    expect(page).to have_content("Not started")
  end

  it "forbids the user from accessing change requests for a different application" do
    stub_request(:get, "https://default.bops-care.link/api/v1/planning_applications/28/validation_requests?change_access_id=345443543")
    .to_return(status: 401, body: "{}")
    stub_successful_get_planning_application

    visit "/validation_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_content("Not Found")
  end

  it "displays the necessary information about the planning application associated with the change request" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/validation_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_content("11 Mel Gardens, London, SE16 3RQ")
    expect(page).to have_content("Date received: 23 April 2021")
    expect(page).to have_content("00000028")
  end

  it "displays the description of the change request on the change request page" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/validation_requests?planning_application_id=28&change_access_id=345443543"

    stub_get_description_change_validation_request(
      id: 18,
      planning_id: 28,
      change_access_id: 345_443_543,
      response_body:
        {
          "id": 18,
          "state": "open",
          "proposed_description": "This is a better description",
          "response_due": "2022-7-1",
        },
      status: 200,
    )

    click_link("Description", match: :first)

    expect(page).to have_content("This is a better description")
  end

  it "allows the user to see cancelled change requests associated with their application" do
    stub_cancelled_change_requests
    stub_successful_get_planning_application

    visit "/validation_requests?planning_application_id=28&change_access_id=345443543"

    within("#description-change-validation-requests") do
      expect(page).to have_link("Description", href: "/description_change_validation_requests/18?change_access_id=345443543&planning_application_id=28")
      expect(page).to have_content("Cancelled")
    end

    within("#other-change-validation-requests") do
      expect(page).to have_link("Other request", href: "/other_change_validation_requests/4?change_access_id=345443543&planning_application_id=28")
      expect(page).to have_content("Cancelled")
    end

    within("#red-line-boundary-change-validation-requests") do
      expect(page).to have_link("Red Line Boundary", href: "/red_line_boundary_change_validation_requests/10?change_access_id=345443543&planning_application_id=28")
      expect(page).to have_content("Cancelled")
    end

    within("#replacement-document-validation-requests") do
      expect(page).to have_link("20210512_162911.jpg", href: "/replacement_document_validation_requests/8?change_access_id=345443543&planning_application_id=28")
      expect(page).to have_content("Cancelled")
    end

    within("#additional-document-validation-requests") do
      expect(page).to have_link("New document", href: "/additional_document_validation_requests/4?change_access_id=345443543&planning_application_id=28")
      expect(page).to have_content("Cancelled")
    end
  end

  it "has the correct page title for the index page" do
    stub_successful_get_change_requests
    stub_successful_get_planning_application

    visit "/validation_requests?planning_application_id=28&change_access_id=345443543"

    expect(page).to have_title "Back-Office Planning System"
  end
end
