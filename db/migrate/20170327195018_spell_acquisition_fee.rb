class SpellAcquisitionFee < ActiveRecord::Migration[5.0]
  def up
    rename_column :lease_calculators, :aquisition_fee_cents, :acquisition_fee_cents
  end
  def down
    rename_column :lease_calculators, :acquisition_fee_cents, :aquisition_fee_cents
  end
end
