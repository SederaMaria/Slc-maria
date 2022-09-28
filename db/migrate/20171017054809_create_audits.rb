class CreateAudits < ActiveRecord::Migration[5.0]
  def change
    create_table :audits do |t|
      t.integer :audited_id
      t.string :audited_type
      t.references :user
      t.text :audited_changes
      t.timestamps
    end
  end
end
