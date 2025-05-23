# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Site notices", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"
  end

  it "allows the user to see a planning application if it's public" do
    stub_successful_get_planning_application

    visit "/planning_applications/22-00128-LDCP/site_notices/download"

    expect(page).to have_content("Download your site notice")
    expect(page).to have_content("11 Mel Gardens, Southwark, SE16 3RQ")
  end

  it "shows 404 if not found" do
    stub_unsuccessful_get_planning_application

    visit "/planning_applications/22-99999-LDCP/site_notices/download"

    expect(page).to have_content("Not Found")
  end

  it "shows 404 if officer hasn't made planning application public" do
    stub_successful_get_private_planning_application
    stub_successful_get_local_authority

    visit "/planning_applications/22-00129-LDCP/site_notices/download"

    expect(page).to have_content("Not Found")
  end
end
