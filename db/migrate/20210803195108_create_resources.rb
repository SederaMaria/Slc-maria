class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.string :name, null: false, index: {unique: true}
      t.boolean :is_active, default: true, null: false
      t.references :created_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_resources_created_by_on_admin_user_id' }
      t.references :updated_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_resources_updated_by_on_admin_user_id' }      

      t.timestamps
    end
  end
end
