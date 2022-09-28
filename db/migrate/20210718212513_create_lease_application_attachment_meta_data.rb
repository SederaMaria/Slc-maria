class CreateLeaseApplicationAttachmentMetaData < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_attachment_meta_data do |t|
      t.references :lease_application, null: false, foreign_key: true, index: { name: 'index_attachment_meta_data_on_lease_application_id' }
      t.references :file_attachment_type, null: false, foreign_key: true, index: { name: 'index_attachment_meta_data_on_file_attachment_type_id' }
      t.timestamps
    end
  end
end
