# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Planning applications", type: :system do
  include_context "local_authority_contact_details"

  before do
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"

    ENV["OS_VECTOR_TILES_API_KEY"] = "testtest"
    allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(instance_double("response", status: 200, body: "{}")) # rubocop:disable RSpec/VerifiedDoubleReference

    stub_request(:get, "https://api.os.uk/search/places/v1/find").with(query: hash_including({}))
  end

  it "allows the user to submit a comment" do
    stub_successful_get_planning_application
    stub_successful_get_local_authority
    stub_successful_post_neighbour_response(
      28,
      name: "Keira Walsh",
      email: "keira@email.com",
      address: "123 Made Up street",
      response: "Access: I think the access will be good/nOther: I like this neighbour",
      summary_tag: "supportive"
    )

    visit "/planning_applications/28"

    click_link "this link"

    expect(page).to have_content("Comment on a planning application")
    click_link "Start now"

    expect(page).to have_content("Your details")

    click_button "Continue"

    expect(page).to have_content("Enter your name")

    fill_in "Full name", with: "Keira Walsh"
    fill_in "Email", with: "keira@email.com"
    fill_in "Address", with: "123 Made Up street"

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
      28,
      name: "Lucy Bronze",
      email: "keira@email.com",
      address: "123 Made Up street",
      response: "Noise: It will be too noisy/nOther: I like this neighbour",
      summary_tag: "supportive"
    )

    visit "/planning_applications/28"

    click_link "this link"

    expect(page).to have_content("Comment on a planning application")
    click_button "Start now"

    expect(page).to have_content("Your details")

    fill_in "Full name", with: "Keira Walsh"
    fill_in "Email", with: "keira@email.com"
    fill_in "Address", with: "123 Made Up street"

    click_button "Continue"

    expect(page).to have_content("How do you feel about the proposed work?")

    choose "I support the application"

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

    click_button "Back"
    click_button "Back"
    click_button "Back"

    fill_in "Full name", with: "Lucy Bronze"

    click_button "Continue"
    click_button "Continue"

    uncheck "Access"
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

    expect(page).not_to have_content("Other")
    expect(page).not_to have_content("I like this neighbour")

    click_button "Send"

    expect(page).to have_content("We've got your comments")
  end
end
