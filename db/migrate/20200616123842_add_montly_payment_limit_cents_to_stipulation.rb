class AddMontlyPaymentLimitCentsToStipulation < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_application_stipulations, :monthly_payment_limit_cents, :integer, default: 0, null: false
  end
end
