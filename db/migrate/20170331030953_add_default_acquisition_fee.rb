class AddDefaultAcquisitionFee < ActiveRecord::Migration[5.0]
  def change
    change_column_default :application_settings, :acquisition_fee_cents, from: 0, to: 59500
  end
end
