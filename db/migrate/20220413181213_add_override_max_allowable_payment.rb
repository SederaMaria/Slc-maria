class AddOverrideMaxAllowablePayment < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_application_payment_limits, :override_max_allowable_payment_cents, :integer
    add_column :lease_application_payment_limits, :override_variance_cents, :integer
  end
end
