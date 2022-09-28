class AddNadaRoughValueToLeaseCalculators < ActiveRecord::Migration[5.1]
  def change
    add_monetize :lease_calculators, :nada_rough_value
  end
end
