class RenameMarkupPercentage < ActiveRecord::Migration[5.0]
  def change
    rename_column :lease_calculators, 
      :dealer_participation_markup_percentage_cents, 
      :dealer_participation_markup_percentage
  end
end
