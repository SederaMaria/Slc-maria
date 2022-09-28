class AddOldUrlToLeaseApplicationAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_application_attachments, :old_url, :string
  end
end
