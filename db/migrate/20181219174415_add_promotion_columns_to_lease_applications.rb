class AddPromotionColumnsToLeaseApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :promotion_name, :string
    add_column :lease_applications, :promotion_value, :float
  end
end
