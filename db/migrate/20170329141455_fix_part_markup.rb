class FixPartMarkup < ActiveRecord::Migration[5.0]
  def change
    remove_column :lease_calculators, :dealer_participation_markup_percentage
    add_column :lease_calculators, :dealer_participation_markup, :decimal, scale: 2, precision: 3, default: 0.00
  end
end
