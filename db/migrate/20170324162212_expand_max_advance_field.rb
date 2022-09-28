class ExpandMaxAdvanceField < ActiveRecord::Migration[5.0]
  def change
    change_column :credit_tiers, :maximum_advance_percentage, :decimal, precision: 5, scale: 2
  end
end
