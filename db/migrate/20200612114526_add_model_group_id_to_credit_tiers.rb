class AddModelGroupIdToCreditTiers < ActiveRecord::Migration[5.1]
  def change
    add_reference :credit_tiers, :model_group, foreign_key: true
  end
end
