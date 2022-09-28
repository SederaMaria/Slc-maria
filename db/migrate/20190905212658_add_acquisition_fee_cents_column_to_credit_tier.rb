class AddAcquisitionFeeCentsColumnToCreditTier < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_tiers, :acquisition_fee_cents, :integer, default: 99500
  end
end
