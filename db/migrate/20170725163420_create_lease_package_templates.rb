class CreateLeasePackageTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :lease_package_templates do |t|
      t.string :name, null: false
      t.string :lease_package_template
      t.integer :document_type, null: false #enum
      t.string :us_states, array: true, default: [], null: false
      t.timestamps
    end
    add_index :lease_package_templates, :name, unique: true
  end
end
