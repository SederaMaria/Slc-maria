class AddCustomLabelToMileageTier < ActiveRecord::Migration[5.1]
  def change
    add_column :mileage_tiers, :custom_label, :string
  end
end
