# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Planning applications", type: :system do
  include_context "local_authority_contact_details"
  include ActionDispatch::TestProcess::FixtureFile

  before do
    ENV["OS_VECTOR_TILES_API_KEY"] = "testtest"
    ENV["API_BEARER"] = "123"
    ENV["PROTOCOL"] = "https"

    stub_successful_get_local_authority
  end

  context "when planning application is closed" do
    before do
      stub_get_planning_application(
        "test_planning_application.json",
        additional_fields:
          {
            status: "closed"
          }
      )

      visit "/planning_applications/28"
    end

    it "shows that comments will no longer be accepted" do
      within(".contact-box") do
        within(".govuk-tag.govuk-tag--grey") do
          expect(page).to have_content("closed")
        end

        expect(page).to have_content("This application has been withdrawn or cancelled")
        expect(page).to have_content("We can no longer consider comments about this application.")
      end
    end
  end

  context "when planning application has been determined" do
    context "when planning application has been granted" do
      before do
        stub_get_planning_application(
          "test_planning_application.json",
          additional_fields:
            {
              decision: "granted",
              determined_at: "2023-04-23T10:15:52.855Z"
            }
        )

        visit "/planning_applications/28"
      end

      it "shows the granted status and provides a link to the decision notice" do
        within(".contact-box") do
          within(".govuk-tag.govuk-tag--green") do
            expect(page).to have_content("Granted")
          end

          expect(page).to have_content("The application has been granted")
        end
      end
    end

    context "when planning application has been granted (not required)" do
      before do
        stub_get_planning_application(
          "test_planning_application.json",
          additional_fields:
            {
              decision: "granted_not_required",
              determined_at: "2023-04-23T10:15:52.855Z"
            }
        )

        visit "/planning_applications/28"
      end

      it "shows the granted (not required) status and provides a link to the decision notice" do
        within(".contact-box") do
          within(".govuk-tag.govuk-tag--green") do
            expect(page).to have_content("Granted not required")
          end

          expect(page).to have_content("The application has been granted")

          expect(page).to have_link(
            "View decision notice",
            href: "#{ENV.fetch("PROTOCOL", nil)}://default.#{ENV.fetch("API_HOST", nil)}/public/planning_applications/28/decision_notice"
          )
        end
      end
    end

    context "when planning application has been refused" do
      before do
        stub_get_planning_application(
          "test_planning_application.json",
          additional_fields:
            {
              decision: "refused",
              determined_at: "2023-04-23T10:15:52.855Z"
            }
        )

        visit "/planning_applications/28"
      end

      it "shows the refused status and provides a link to the decision notice" do
        within(".contact-box") do
          within(".govuk-tag.govuk-tag--red") do
            expect(page).to have_content("Refused")
          end

          expect(page).to have_content("The application has been refused")

          expect(page).to have_link(
            "View decision notice",
            href: "#{ENV.fetch("PROTOCOL", nil)}://default.#{ENV.fetch("API_HOST", nil)}/public/planning_applications/28/decision_notice"
          )
        end
      end
    end
  end

  context "when planning application has not been determined" do
    context "when planning application consultation is in progress" do
      before do
        stub_get_planning_application(
          "test_planning_application.json",
          additional_fields:
            {
              consultation: {
                end_date: "2023-11-23T10:15:52.855Z"
              }
            }
        )

        travel_to(DateTime.new(2023, 11, 4)) do
          visit "/planning_applications/28"
        end
      end

      it "allows neighbour to make a comment" do
        within(".contact-box") do
          within(".govuk-tag.govuk-tag--grey") do
            expect(page).to have_content("under consultation")
          end

          expect(page).to have_content("Comment on this application by 23 November 2023")

          expect(page).to have_link("Submit a comment")
        end
      end
    end

    context "when planning application consultation has expired" do
      before do
        stub_get_planning_application(
          "test_planning_application.json",
          additional_fields:
            {
              consultation: {
                end_date: "2023-11-23T10:15:52.855Z"
              }
            }
        )

        travel_to(DateTime.new(2023, 11, 24)) do
          visit "/planning_applications/28"
        end
      end

      it "allows neighbour to make a comment with a notice that it might not be taken into consideration" do
        within(".contact-box") do
          within(".govuk-tag.govuk-tag--grey") do
            expect(page).to have_content("in review")
          end

          expect(page).to have_content("Comment on this application by 23 November 2023")
          expect(page).to have_content(
            "If we receive your comments after 23 November 2023, we may not be able to take them into consideration if a decision has already been made."
          )

          expect(page).to have_link("Submit a comment")
        end
      end
    end
  end
end
