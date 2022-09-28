class AddNewUsedToLeaseCalculators < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_calculators, :new_used, :string
  end
end
