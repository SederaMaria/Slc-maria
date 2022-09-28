class RemoveGlobalInColumnName < ActiveRecord::Migration[5.1]
  def change
    
    rename_column  :us_states, :global_security_deposit, :security_deposit
    rename_column  :us_states, :enable_global_security_deposit, :enable_security_deposit
    
    rename_column  :credit_tiers, :global_security_deposit, :security_deposit
    rename_column  :credit_tiers, :enable_global_security_deposit, :enable_security_deposit
    
    rename_column  :dealerships, :global_security_deposit, :security_deposit 
    rename_column  :dealerships, :enable_global_security_deposit, :enable_security_deposit 
    
  end
end
