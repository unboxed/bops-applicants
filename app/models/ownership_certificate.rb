# frozen_string_literal: true

class OwnershipCertificate < ApplicationRecord
  has_many :land_owners

  accepts_nested_attributes_for :land_owners
end
