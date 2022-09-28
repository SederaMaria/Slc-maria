class AddColumnsToCalculator < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_calculators, :gross_capitalized_cost_cents, :integer, default: 0, null: false
  end
end
