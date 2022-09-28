class CreateModelGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :model_groups do |t|
      t.string :name
      t.decimal :participation_minimum
      t.decimal :new_residual_factor_24_months
      t.decimal :new_residual_factor_36_months
      t.decimal :new_residual_factor_48_months
      t.decimal :used_residual_reduction_factor
      t.timestamps
    end
  end
end
