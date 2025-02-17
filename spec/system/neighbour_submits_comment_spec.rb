# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Planning applications", js: true, type: :system do
  include_context "local_authority_contact_details"
  include ActionDispatch::TestProcess::FixtureFile

  before do
    ENV["OS_VECTOR_TILES_API_KEY"] = "testtest"
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"
    stub_request(:get, "https://api.os.uk/search/places/v1/find").with(query: hash_including({}))
  end

  it "allows the user to submit a comment" do
    stub_successful_get_planning_application
    stub_successful_get_local_authority

    stub_successful_post_neighbour_response(
      planning_application_id: 28,
      name: "Keira Walsh",
      email: "keira@email.com",
      address: "123 Made Up street",
      response: "I think the access will be good\n\nI like this neighbour\n\n",
      summary_tag: "supportive",
      files: "",
      tags: %w[access other]
    )

    visit "/planning_applications/22-00128-LDCP"

    click_link "Submit a comment"

    expect(page).to have_content("Comment on a planning application")
    click_link "Start now"

    expect(page).to have_content("Your details")

    click_button "Continue"

    expect(page).to have_content("Enter your name")

    fill_in "Full name", with: "Keira Walsh"
    fill_in "Email (optional)", with: "keira@email.com"
    fill_in "Address (optional)", with: "123 Made Up street"

    click_button "Continue"
    click_button "Continue"

    expect(page).to have_content("How do you feel about the proposed work?")

    click_button "Continue"

    expect(page).to have_content("Select how you feel about the application")

    choose "I support the application"

    click_button "Continue"

    expect(page).to have_content("Share your comments about the proposed work")

    click_button "Continue"

    expect(page).to have_content("Enter a comment")

    check "Access"

    fill_in "Tell us about how the proposed work could affect access to buildings, premises or other existing spaces",
      with: "I think the access will be good"

    check "Other"

    fill_in "Use this space to share any other comments about this application", with: "I like this neighbour"

    click_button "Continue"

    expect(page).to have_content("Keira Walsh")
    expect(page).to have_content("keira@email.com")
    expect(page).to have_content("123 Made Up street")
    expect(page).to have_content("Access")
    expect(page).to have_content("I think the access will be good")
    expect(page).to have_content("Other")
    expect(page).to have_content("I like this neighbour")

    click_button "Send"

    expect(page).to have_content("We've got your comments")
  end

  it "allows users to go back and change answers" do
    stub_successful_get_planning_application
    stub_successful_get_local_authority
    stub_successful_post_neighbour_response(
      planning_application_id: 28,
      name: "Lucy Bronze",
      response: "It will be too noisy\n\nI like this neighbour\n\n",
      address: "123 Made Up street",
      email: "keira@email.com",
      summary_tag: "supportive",
      files: "",
      tags: %w[noise other]
    )

    visit "/planning_applications/22-00128-LDCP"

    click_link "Submit a comment"

    expect(page).to have_content("Comment on a planning application")
    click_link "Start now"

    expect(page).to have_content("Your details")

    fill_in "Full name", with: "Keira Walsh"
    fill_in "Email (optional)", with: "keira@email.com"
    fill_in "Address (optional)", with: "123 Made Up street"

    click_button "Continue"
    click_button "Continue"

    expect(page).to have_content("How do you feel about the proposed work?")

    choose "I support the application"

    click_button "Continue"

    expect(page).to have_content("Share your comments about the proposed work")

    check "Design, size or height of new buildings or extensions"

    fill_in "We cannot consider comments about loss of view",
      with: "I think the design will be good"

    check "Other"

    fill_in "Use this space to share any other comments about this application", with: "I like this neighbour"

    click_button "Continue"

    expect(page).to have_content("Keira Walsh")
    expect(page).to have_content("keira@email.com")
    expect(page).to have_content("123 Made Up street")
    expect(page).to have_content("Design")
    expect(page).to have_content("I think the design will be good")
    expect(page).to have_content("Other")
    expect(page).to have_content("I like this neighbour")

    click_button "Back"
    click_button "Back"
    click_button "Back"

    fill_in "Full name", with: "Lucy Bronze"

    click_button "Continue"
    click_button "Continue"

    uncheck "Design, size or height of new buildings or extensions"
    check "Noise from new uses"
    fill_in "We cannot refuse permission because of construction noise. We can consider the impact from new uses once the work is complete",
      with: "It will be too noisy"

    click_button "Continue"

    expect(page).to have_content("Lucy Bronze")
    expect(page).to have_content("keira@email.com")
    expect(page).to have_content("123 Made Up street")
    expect(page).to have_content("Noise")
    expect(page).to have_content("It will be too noisy")
    expect(page).to have_content("Other")
    expect(page).to have_content("I like this neighbour")

    expect(page).not_to have_content("Design")
    expect(page).not_to have_content("I think the design will be good")

    click_button "Send"

    expect(page).to have_content("We've got your comments")
  end

  #  WebMock does not support matching body for multipart/form-data requests yet
  xit "allows users to upload files" do
    stub_successful_get_planning_application
    stub_successful_get_local_authority

    stub_successful_post_neighbour_response(
      planning_application_id: 28,
      name: "Keira Walsh",
      email: "keira@email.com",
      address: "123 Made Up street",
      response: "I think the access will be good\n\n",
      summary_tag: "supportive",
      files: fixture_file_upload(Rails.root.join("spec/fixtures/images/proposed-floorplan.png"), "proposed-floorplan/png"),
      tags: ["acess"]
    )

    visit "/planning_applications/22-00128-LDCP"

    click_link "this link"

    click_link "Start now"

    expect(page).to have_content("Your details")

    fill_in "Full name", with: "Keira Walsh"
    fill_in "Email (optional)", with: "keira@email.com"
    fill_in "Address (optional)", with: "123 Made Up street"

    click_button "Continue"
    click_button "Continue"

    expect(page).to have_content("How do you feel about the proposed work?")

    choose "I support the application"

    click_button "Continue"

    expect(page).to have_content("Share your comments about the proposed work")

    check "Access"

    fill_in "Tell us about how the proposed work could affect access to buildings, premises or other existing spaces",
      with: "I think the access will be good"

    click_button "Continue"

    expect(page).to have_content("Keira Walsh")
    expect(page).to have_content("keira@email.com")
    expect(page).to have_content("123 Made Up street")
    expect(page).to have_content("Access")
    expect(page).to have_content("I think the access will be good")

    attach_file("Upload documents", "spec/fixtures/images/proposed-floorplan.png")

    click_button "Send"

    expect(page).to have_content("We've got your comments")
  end
end
