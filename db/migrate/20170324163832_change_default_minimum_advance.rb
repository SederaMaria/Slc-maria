class ChangeDefaultMinimumAdvance < ActiveRecord::Migration[5.0]
  def change
    change_column_default :credit_tiers, :minimum_fi_advance_percentage, 1000.00
  end
end
