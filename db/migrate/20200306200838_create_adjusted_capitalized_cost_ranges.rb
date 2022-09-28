class CreateAdjustedCapitalizedCostRanges < ActiveRecord::Migration[5.1]
  def change
    create_table :adjusted_capitalized_cost_ranges do |t|
      t.integer :acquisition_fee_cents
      t.integer :adjusted_cap_cost_lower_limit
      t.integer :adjusted_cap_cost_upper_limit
      t.references :credit_tier, foreign_key: true
      t.datetime :effective_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
