class AddIncomeStipulationsToStipulation < ActiveRecord::Migration[5.1]
  def change
    add_column :stipulations, :pre_income_stipulation, :boolean, default: false
    add_column :stipulations, :post_income_stipulation, :boolean, default: false
  end
end
