# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Planning applications", type: :system do
  include_context "local_authority_contact_details"

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"
  end

  it "allows the user to see a planning application" do
    stub_successful_get_planning_application
    stub_successful_get_local_authority

    visit "/planning_applications/28"

    expect(page).to have_content("11 Mel Gardens, Southwark, SE16 3RQ")
    expect(page).to have_content("Add a chimney stack")
    expect(page).to have_css("img[src*='http://example.com/document_path.pdf']")
    expect(page).not_to have_content("This is the site plan")
    expect(page).to have_content("To comment on this application, please send an email to planning@southwark.com and use the application reference number above as the email subject")
    expect(page).to have_content("PLAN02")
    expect(page).to have_css("img[src*='http://example.com/document_path2.pdf']")
    expect(page).to have_content("This is the proposed side elevation")
  end

  it "shows 404 if not found" do
    stub_unsuccessful_get_planning_application

    visit "/planning_applications/100"

    expect(page).to have_content("Not Found")
  end
end
