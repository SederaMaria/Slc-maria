class AddGlobalSecurityDepositToApplicationSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :application_settings, :global_security_deposit, :integer, default: 0
    add_column :application_settings, :enable_global_security_deposit, :boolean, default: false
  end
end