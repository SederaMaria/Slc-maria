class AddResidualReductionPercentageToModelGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :model_groups, :residual_reduction_percentage, :decimal, default: 0, null: false
  end
end
