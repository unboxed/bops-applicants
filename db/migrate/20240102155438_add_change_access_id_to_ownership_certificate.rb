# frozen_string_literal: true

class AddChangeAccessIdToOwnershipCertificate < ActiveRecord::Migration[7.0]
  def change
    add_column :ownership_certificates, :change_access_id, :string
  end
end
