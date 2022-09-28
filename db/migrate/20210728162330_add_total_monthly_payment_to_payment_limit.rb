class AddTotalMonthlyPaymentToPaymentLimit < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_application_payment_limits, :total_monthly_payment_cents, :integer, default: 0, null: false
  end
end
