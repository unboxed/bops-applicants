# frozen_string_literal: true

module PlanningApplicationHelper
  def full_address
    "#{address_1}, #{town}, #{postcode}"
  end

  def reference
    id.to_s.rjust(8, "0")
  end

  def date_received
    created_at.strftime("%e %B %Y")
  end
end
