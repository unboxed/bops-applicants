# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bops::AdditionalDocumentValidationRequest, type: :model do
  describe "validations" do
    let(:additional_document_validation_request) { described_class.new }

    describe "#file" do
      it "validates presence" do
        expect {
          additional_document_validation_request.valid?
        }.to change {
          additional_document_validation_request.errors[:files]
        }.to ["Please choose at least one file to upload"]
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
