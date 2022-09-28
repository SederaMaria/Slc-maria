class AddSecurityDepositToUsStates < ActiveRecord::Migration[5.1]
  def change
    add_column :us_states, :global_security_deposit, :integer, default: 0, null: false
    add_column :us_states, :enable_global_security_deposit, :boolean, :default => false
  end
end
