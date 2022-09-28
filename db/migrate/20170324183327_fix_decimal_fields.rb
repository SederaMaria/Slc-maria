class FixDecimalFields < ActiveRecord::Migration[5.0]
  def up
    change_column :credit_tiers, :minimum_fi_advance_percentage, :decimal, precision: 6, scale: 2
  end

  def down
    change_column :credit_tiers, :minimum_fi_advance_percentage, :decimal, precision: 4, scale: 2
  end
end
