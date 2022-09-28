class AddResidualReductionPercentage60ToApplicationSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :application_settings, 
      :residual_reduction_percentage_60, 
      :decimal, 
      default: 65.0, 
      null: false
  end
end
