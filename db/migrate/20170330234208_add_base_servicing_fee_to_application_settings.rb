class AddBaseServicingFeeToApplicationSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :application_settings, :base_servicing_fee_cents, :integer, default: 500, null: false
  end
end
