class AddDescriptionToLeaseApplicationAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_application_attachments, :description, :string
  end
end
