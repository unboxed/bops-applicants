# frozen_string_literal: true

class OwnershipCertificate < ApplicationRecord
  has_many :land_owners, dependent: :destroy

  accepts_nested_attributes_for :land_owners

  validates_presence_of :certificate_type
end
