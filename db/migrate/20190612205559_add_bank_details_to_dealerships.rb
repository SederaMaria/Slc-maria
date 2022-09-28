class AddBankDetailsToDealerships < ActiveRecord::Migration[5.1]
  def change
  	add_column :dealerships, :bank_name, :string
  	add_column :dealerships, :account_number, :bigint
  	add_column :dealerships, :routing_number, :string
  	add_column :dealerships, :account_type, :integer
  end
end
