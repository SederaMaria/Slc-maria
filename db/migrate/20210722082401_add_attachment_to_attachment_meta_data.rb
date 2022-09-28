class AddAttachmentToAttachmentMetaData < ActiveRecord::Migration[6.0]
  def change
    add_reference :lease_application_attachment_meta_data, :lease_application_attachment, foreign_key: true, null: false, index: { name: 'index_attachment_meta_data_on_lease_application_attachment_id' }
  end
end
