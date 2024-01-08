# frozen_string_literal: true

FactoryBot.define do
  factory :land_owner do
    ownership_certificate
    name { "Tom" }
    address_1 { "123 street" }
    postcode { "E16LT" }
    notice_given_at { Time.zone.now }
  end
end
