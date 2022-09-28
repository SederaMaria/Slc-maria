class CreateLeaseApplicationAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :lease_application_attachments do |t|
      t.string :upload
      t.references :lease_application, foreign_key: true, index: true
      t.text :notes

      t.timestamps
    end
  end
end
