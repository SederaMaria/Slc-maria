class ChangeMinimumReserveCentsDefault < ActiveRecord::Migration[5.0]
  def up
    change_column_default :lease_calculators, :minimum_reserve_cents, 20000 #$200 
    LeaseCalculator.update_all(minimum_reserve_cents: 20000)
  end

  def down
    change_column_default :lease_calculators, :minimum_reserve_cents, 0 #$200 
    LeaseCalculator.update_all(minimum_reserve_cents: 0)
  end


end
