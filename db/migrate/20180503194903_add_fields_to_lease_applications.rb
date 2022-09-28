class AddFieldsToLeaseApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :first_payment_date, :date
    add_column :lease_applications, :payment_aba_routing_number, :string
    add_column :lease_applications, :payment_account_number, :string
    add_column :lease_applications, :payment_bank_name, :string
    add_column :lease_applications, :payment_account_type, :integer, default: 0
  end
end
