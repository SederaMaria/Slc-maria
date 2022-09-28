class AddAcquisitionFeeToApplicationSettings < ActiveRecord::Migration[5.0]
  def change
    change_table :application_settings do |t|
      t.monetize :acquisition_fee
    end
  end
end
