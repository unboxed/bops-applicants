# frozen_string_literal: true

require "rails_helper"

RSpec.describe LandOwner, type: :model do
  describe "validations" do
    let(:land_owner) { described_class.new }

    describe "#certificate_type" do
      it "validates presence" do
        expect do
          land_owner.valid?
        end.to change {
          land_owner.errors[:name]
        }.to ["Name can't be blank"]
      end
    end
  end
end
