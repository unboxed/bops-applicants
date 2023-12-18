class CreateOwnershipCertificate < ActiveRecord::Migration[7.0]
  def change
    create_table :ownership_certificates do |t|
      t.string :certificate_type, null: false
      t.boolean :know_owners, null: false, default: true
      t.integer :number_of_owners
      t.string :notification_of_owners
      t.bigint :planning_application_id
      t.timestamps
    end
  end
end
