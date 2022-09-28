class AddAccFiAfToLeaseCalculator < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_calculators, :acc_less_fi_less_af_cents, :integer, default: 0, null: false
  end
end
