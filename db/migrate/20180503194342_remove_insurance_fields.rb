class RemoveInsuranceFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :insurances, :first_payment_date
    remove_column :insurances, :aba_routing_number
    remove_column :insurances, :account_number
    remove_column :insurances, :bank_name
    remove_column :insurances, :account_type
  end
end
