# frozen_string_literal: true

class OwnershipCertificate < ApplicationRecord
  has_many :land_owners, dependent: :destroy

  accepts_nested_attributes_for :land_owners

  validates :certificate_type, presence: true

  def relevant_land_owners_attributes
    if land_owners.any?
      land_owners.map do |land_owner|
        land_owner.attributes.slice("name", "address_1", "address_2", "town", "country", "postcode", "notice_given_at")
      end
    else
      []
    end
  end
end
