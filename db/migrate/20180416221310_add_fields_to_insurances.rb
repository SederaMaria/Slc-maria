class AddFieldsToInsurances < ActiveRecord::Migration[5.1]
  def change
    add_column :insurances, :first_payment_date, :date
    add_column :insurances, :aba_routing_number, :string
    add_column :insurances, :account_number, :string
    add_column :insurances, :bank_name, :string
    add_column :insurances, :account_type, :integer, default: 0
  end
end
