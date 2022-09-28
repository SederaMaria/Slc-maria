class AddCreditAvailableAndMontlyPaymentToCredco < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_application_credcos, :revolving_credit_available, :string
    add_column :lease_application_credcos, :open_auto_monthly_payment, :string
  end
end
