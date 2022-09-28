class RemoveMinimumFiAdvancePercentageFromCreditTiers < ActiveRecord::Migration[5.0]
  def change
    remove_column :credit_tiers, :minimum_fi_advance_percentage
  end
end
