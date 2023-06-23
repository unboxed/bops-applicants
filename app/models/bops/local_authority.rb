# frozen_string_literal: true

module Bops
  class LocalAuthority
    class << self
      def find(local_authority_subdomain)
        Apis::Bops::Client.get_local_authority(local_authority_subdomain)
      end
    end
  end
end
