class AddUploadS3ToLeaseApplicationAttachment < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_application_attachments, :upload_s3, :string
  end
end
