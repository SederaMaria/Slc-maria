class CreateFileAttachmentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :file_attachment_types do |t|
      t.string :label, null: false
      t.timestamps
    end
  end
end
