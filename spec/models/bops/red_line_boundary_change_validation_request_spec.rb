# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bops::RedLineBoundaryChangeValidationRequest, type: :model do
  describe "validations" do
    let(:red_line_boundary_change_validation_request) { described_class.new }
    let(:not_approved_request) { described_class.new(approved: "no") }

    describe "#approved" do
      it "validates presence" do
        expect do
          red_line_boundary_change_validation_request.valid?
        end.to change {
          red_line_boundary_change_validation_request.errors[:approved]
        }.to ["Please select an option"]
      end
    end

    describe "#rejection_reason" do
      it "validates presence when not approved" do
        expect do
          not_approved_request.valid?
        end.to change {
          not_approved_request.errors[:rejection_reason]
        }.to ["Please indicate why you disagree with the proposed red line boundary."]
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
