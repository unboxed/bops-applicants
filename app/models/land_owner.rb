# frozen_string_literal: true

class LandOwner < ApplicationRecord
  belongs_to :ownership_certificate

  validates :name, presence: true
end
