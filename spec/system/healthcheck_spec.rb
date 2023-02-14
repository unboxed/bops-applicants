require "rails_helper"

RSpec.describe "healthcheck", type: :system do
  it "ensure we can perform a healthcheck" do
    visit healthcheck_path

    expect(page.body).to have_content("OK")
  end
end
