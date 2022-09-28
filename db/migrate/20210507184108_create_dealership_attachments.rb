class CreateDealershipAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :dealership_attachments do |t|
      t.string :upload
      t.references :dealership, foreign_key: true, index: true
      t.references :admin_user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
