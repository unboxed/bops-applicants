# frozen_string_literal: true

require "rails_helper"

RSpec.describe OwnershipCertificate, type: :model do
  describe "validations" do
    let(:ownership_certificate) { described_class.new }

    describe "#certificate_type" do
      it "validates presence" do
        expect do
          ownership_certificate.valid?
        end.to change {
          ownership_certificate.errors[:certificate_type]
        }.to ["Certificate type can't be blank"]
      end
    end
  end
end
