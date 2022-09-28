class AddModelYearToLeaseCalculators < ActiveRecord::Migration[6.0]
  def change
    add_reference :lease_calculators, :model_year, foreign_key: true, index: true
  end
end
