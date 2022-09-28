class AddDefaultsToCreditTierPercents < ActiveRecord::Migration[5.0]
  def change
      change_column_default :credit_tiers, :minimum_fi_advance_percentage, 0 #must store 10.25
      change_column_default :credit_tiers, :maximum_fi_advance_percentage, 0 #must store 10.25
      change_column_default :credit_tiers, :maximum_advance_percentage, 0 #must store 10.25
  end
end
