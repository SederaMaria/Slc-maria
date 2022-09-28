class DropUploadCloudinaryFromLeaseApplicationAttachments < ActiveRecord::Migration[5.1]
  def up
  	remove_columns :lease_application_attachments, :upload_cloudinary, :old_url
  end

  def down
  	#this migration destroys data, it really can't be undone...
  	add_column :lease_application_attachments, :upload_cloudinary, :string
  	add_column :lease_application_attachments, :old_url, :string
  end
end
