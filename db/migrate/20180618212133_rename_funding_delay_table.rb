class RenameFundingDelayTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :lease_application_funding_delays, :funding_delays
  end
end
