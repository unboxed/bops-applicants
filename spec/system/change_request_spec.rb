require "rails_helper"

RSpec.describe "Change requests", type: :system do
  context "Retrieving a list of change requests" do
    it "allows the user to see change requests associated with their application" do
      stub_request(:get, "http://southwark.lvh.me:3000/api/v1/planning_applications/28/change_requests?change_access_id=f3778f8a79787e1b307f4e81bc9ff8")
      .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/test_change_request_index.json")))

      visit "/change_requests?planning_application_id=28&change_access_id=f3778f8a79787e1b307f4e81bc9ff8"

      expect(page).to have_content("Confirm changes to your application description")
      expect(page).to have_content("Description")
      expect(page).to have_content("Not started")
    end

    it "forbids the user from accessing change requests for a different application" do
      stub_request(:get, "http://southwark.lvh.me:3000/api/v1/planning_applications/28/change_requests?change_access_id=f3778f8a79787e1b307f4e81bc9ff8")
      .to_return(status: 401)

      visit "/change_requests?planning_application_id=28&change_access_id=f3778f8a79787e1b307f4e81bc9ff8"

      expect(page).to have_content("Forbidden")
    end

    it "displays the necessary information about the planning application associated with the change request" do
      stub_request(:get, "http://southwark.lvh.me:3000/api/v1/planning_applications/28").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer 123',
        'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: "", headers: {})

      visit "/change_requests?planning_application_id=28&change_access_id=f3778f8a79787e1b307f4e81bc9ff8"

      expect(page).to have_content("11 POWOWOW Gardens, London, SE16 3RQ")
      expect(page).to have_content("Date received: 23 April 2021")
      expect(page).to have_content("00000028")
    end
  end
end
