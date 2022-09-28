class ChangeResidualReductionPercentageDefault < ActiveRecord::Migration[5.0]
  def up
    change_column_default :model_groups, :residual_reduction_percentage, 100
    ModelGroup.where(residual_reduction_percentage: 0).update_all(residual_reduction_percentage: 100)
  end

  def down
    change_column_default :model_groups, :residual_reduction_percentage, 0
    ModelGroup.where(residual_reduction_percentage: 100).update_all(residual_reduction_percentage: 0)
  end
end
