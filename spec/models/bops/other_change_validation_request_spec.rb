# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bops::OtherChangeValidationRequest, type: :model do
  describe "validations" do
    let(:other_change_validation_request) { described_class.new }

    describe "#response" do
      it "validates presence" do
        expect do
          other_change_validation_request.valid?
        end.to change {
          other_change_validation_request.errors[:response]
        }.to ["Enter your response to the planning officer's question."]
      end
    end
  end

  describe "#update" do
    context "when invalid" do
      it "returns false" do
        expect(described_class.new.update).to be_falsey
      end
    end
  end
end
