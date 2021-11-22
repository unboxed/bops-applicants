# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bops::DescriptionChangeValidationRequest, type: :model do
  describe "validations" do
    let(:description_change_validation_request) { described_class.new }
    let(:not_approved_request) { described_class.new(approved: "no") }

    describe "#approved" do
      it "validates presence" do
        expect {
          description_change_validation_request.valid?
        }.to change {
          description_change_validation_request.errors[:approved]
        }.to ["Please select an option"]
      end
    end

    describe "#rejection_reason" do
      it "validates presence when not approved" do
        expect {
          not_approved_request.valid?
        }.to change {
          not_approved_request.errors[:rejection_reason]
        }.to ["Please fill in the reason for disagreeing with the suggested change."]
      end
    end
  end

  describe "#update" do
    context "when invalid" do
      it "returns false" do
        expect(described_class.new.update).to be_falsey
      end

      it "returns false when approved but no reason is present" do
        expect(described_class.new(approved: "no").update).to be_falsey
      end
    end
  end
end
