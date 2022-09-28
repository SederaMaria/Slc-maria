class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.string :action, null: false, index: {unique: true}

      t.references :created_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_actions_created_by_on_admin_user_id' }
      t.references :updated_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_actions_updated_by_on_admin_user_id' }      

      t.timestamps
    end
  end
end
