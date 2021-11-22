# frozen_string_literal: true

module FileTypesHelper
  # Probs should expose this as an endpoint on BOPS to have one source of truth
  def acceptable_file_mime_types
    FileTypes::ACCEPTED.join(",")
  end
end
