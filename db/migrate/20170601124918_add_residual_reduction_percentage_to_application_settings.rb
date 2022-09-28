class AddResidualReductionPercentageToApplicationSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :application_settings, :residual_reduction_percentage_24, :decimal, default: 0.0, null: false
    add_column :application_settings, :residual_reduction_percentage_36, :decimal, default: 0.0, null: false
    add_column :application_settings, :residual_reduction_percentage_48, :decimal, default: 0.0, null: false
  end
end
