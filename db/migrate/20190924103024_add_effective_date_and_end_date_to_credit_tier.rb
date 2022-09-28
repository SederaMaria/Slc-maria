class AddEffectiveDateAndEndDateToCreditTier < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_tiers, :effective_date, :date
    add_column :credit_tiers, :end_date, :date
  end
end
