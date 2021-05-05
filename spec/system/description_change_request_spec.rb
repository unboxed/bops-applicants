require "rails_helper"

RSpec.describe "Change requests", type: :system do
  before do
    ENV["API_BEARER"] = "123"

    stub_successful_get_change_request
    stub_successful_get_planning_application

    visit "/change_requests?planning_application_id=8&change_access_id=345443543"
    click_link "Description"
  end

  def set_headers
    @headers = {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
      "Authorization" => "Bearer 123",
      "User-Agent" => "Ruby",
    }
  end

  def stub_successful_get_individual_change_request
    stub_request(:get, "http://southwark.lvh.me:3000/api/v1/planning_applications/8/change_requests?change_access_id=345443543")
    .with(headers: set_headers)
    .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/test_individual_change_req.json")), headers: {})
  end

  def stub_successful_get_planning_application
    stub_request(:get, "http://southwark.lvh.me:3000/api/v1/planning_applications/8")
    .with(headers: set_headers)
    .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/test_planning_application.json")), headers: {})
  end

  def stub_patch_change_request
    stub_request(:get, "http://southwark.lvh.me:3000/api/v1/planning_applications/8")
    .with(headers: set_headers)
    .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/test_planning_application.json")), headers: {})
  end

  it "allows the user to accept a change request" do
    click_link "Description"

    within "form", text: "Do you agree with the proposed description?" do
      choose "Yes, I agree with the changes made"
    end

    click_button "Save"
    expect(page).to have_content "Change request updated"
  end

  it "allows the user to reject a change request" do
    within "form", text: "Do you agree with the changes made to your application description?" do
      choose "No, I disagree with the changes made"
      fill_in "Please indicate why you disagree with the changes and provided your suggested wording for the description?", with: "I am building a bird house not a roof extension."
    end

    click_button "Save"
    expect(page).to have_content "Change request updated"
  end

  it "does not allow the user to reject a change request without filling in a rejection reason" do
    within "form", text: "Do you agree with the changes made to your application description?" do
      choose "No, I disagree with the changes made"
    end

    click_button "Save"
    expect(page).to have_content "Change request updated"
  end
end
