class UpdateVertexStatistics < ActiveRecord::Migration[5.1]
  def change
    rename_column :vertex_statistics, :state_user_tax_rate, :state_use_tax_rate
    rename_column :vertex_statistics, :state_user_tax_rate_effective_date, :state_use_tax_rate_effective_date
    rename_column :vertex_statistics, :county_user_tax_rate, :county_use_tax_rate
    rename_column :vertex_statistics, :county_user_tax_rate_effective_date, :county_use_tax_rate_effective_date
    rename_column :vertex_statistics, :city_user_tax_rate, :city_use_tax_rate
    rename_column :vertex_statistics, :city_user_tax_rate_effective_date, :city_use_tax_rate_effective_date

    remove_column :vertex_statistics, :last_changed_date
    remove_column :vertex_statistics, :update_number
  end
end
