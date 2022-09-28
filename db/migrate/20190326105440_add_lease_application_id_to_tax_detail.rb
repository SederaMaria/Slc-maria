class AddLeaseApplicationIdToTaxDetail < ActiveRecord::Migration[5.1]
  def change
    add_column :tax_details, :lease_application_id, :integer
  end
end
