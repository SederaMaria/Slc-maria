class AddUploaderToLeaseApplicationAttachment < ActiveRecord::Migration[5.1]
  def change
    add_reference :lease_application_attachments, :uploader, polymorphic: true, index: false
  end
end
