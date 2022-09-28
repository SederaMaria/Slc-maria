class AddSecurityDepositToCreditTier < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_tiers, :global_security_deposit, :integer, default: 0, null: false
    add_column :credit_tiers, :enable_global_security_deposit, :boolean, :default => false
  end
end
