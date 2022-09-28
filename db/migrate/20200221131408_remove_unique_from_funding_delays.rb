class RemoveUniqueFromFundingDelays < ActiveRecord::Migration[5.1]
  def change
    remove_index :lease_application_funding_delays, name: 'lease_application_funding_delays_unique_index'
    add_index :funding_delays, [:lease_application_id, :funding_delay_reason_id], name: 'funding_delays_unique_index'
  end
end
