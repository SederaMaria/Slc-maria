class CleanModelGroups < ActiveRecord::Migration[5.0]
  def change
    remove_columns :model_groups, :participation_minimum, :new_residual_factor_24_months, :new_residual_factor_36_months, :new_residual_factor_48_months, :used_residual_reduction_factor
  end
end
