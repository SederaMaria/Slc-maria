class RenameAttachmentUploadColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :lease_application_attachments, :upload, :upload_cloudinary
    rename_column :lease_application_attachments, :upload_s3, :upload
  end
end
