# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bops::ReplacementDocumentValidationRequest, type: :model do
  describe "validations" do
    let(:replacement_document_validation_request) { described_class.new }

    describe "#file" do
      it "validates presence" do
        expect do
          replacement_document_validation_request.valid?
        end.to change {
          replacement_document_validation_request.errors[:file]
        }.to ["Choose a file to upload"]
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
