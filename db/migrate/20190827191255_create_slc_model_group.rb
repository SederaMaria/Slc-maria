class CreateSlcModelGroup < ActiveRecord::Migration[5.1]
  def change
    create_table :slc_model_groups do |t|   
      t.string :model
      t.integer :model_year
      t.string :slc_model_group_name
      t.timestamps
    end
  end
end
