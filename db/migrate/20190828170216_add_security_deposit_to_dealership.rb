class AddSecurityDepositToDealership < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :global_security_deposit, :integer, default: 0, null: false
    add_column :dealerships, :enable_global_security_deposit, :boolean, :default => false
  end
end
