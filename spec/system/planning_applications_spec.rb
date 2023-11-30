# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Planning applications", type: :system do
  include_context "local_authority_contact_details"

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"
  end

  it "allows the user to see a planning application if it's public" do
    stub_successful_get_planning_application
    stub_successful_get_local_authority

    visit "/planning_applications/28"

    expect(page).to have_content("11 Mel Gardens, Southwark, SE16 3RQ")
    expect(page).to have_content("Add a chimney stack")
    expect(page).to have_css("img[src*='http://example.com/document_path.pdf']")

    map_selector = find("my-map")
    expect(map_selector["latitude"]).to eq("123")
    expect(map_selector["longitude"]).to eq("-123")

    expect(page).to have_content("Comment on this application")
    expect(page).to have_content("This is the site plan")
    expect(page).to have_content("PLAN02")
    expect(page).to have_css("img[src*='http://example.com/document_path2.pdf']")
    expect(page).to have_content("This is the proposed side elevation")

    expect(page).to have_content("supportive")
    expect(page).to have_content("16/05/20")
    expect(page).to have_content("This is good")
    expect(page).to have_content("objection")
    expect(page).to have_content("17/05/20")
    expect(page).to have_content("This is bad")
    expect(page).to have_content("18/05/20")
    expect(page).to have_content("This is illegal")
  end

  it "shows 404 if not found" do
    stub_unsuccessful_get_planning_application

    visit "/planning_applications/100"

    expect(page).to have_content("Not Found")
  end

  it "shows 404 if officer hasn't made planning application public" do
    stub_successful_get_private_planning_application
    stub_successful_get_local_authority

    visit "/planning_applications/29"

    expect(page).to have_content("Not Found")
  end
end
