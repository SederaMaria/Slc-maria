class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :audits, [:audited_id, :audited_type]
    add_index :audits, [:user_id, :user_type]
    add_index :dealer_representatives_dealerships, :dealer_representative_id, name: 'dealer_rep_idx1'
    add_index :dealer_representatives_dealerships, :dealership_id, name: 'dealer_rep_idx2'
    add_index :dealer_representatives_dealerships, [:dealer_representative_id, :dealership_id], name: 'dealer_rep_idx3'
    add_index :lease_application_attachments, :lessee_id
    add_index :lease_application_attachments, [:uploader_id, :uploader_type], name: 'lease_app_uploader_idx'
    add_index :lease_validations, [:id, :type]
    add_index :notifications, [:notifiable_id, :notifiable_type]
    add_index :related_applications, :origin_application_id
    add_index :related_applications, :related_application_id
  end
end
