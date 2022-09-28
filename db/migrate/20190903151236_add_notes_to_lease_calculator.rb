class AddNotesToLeaseCalculator < ActiveRecord::Migration[5.1]
  def change
  	add_column :lease_calculators, :notes, :string
  end
end
