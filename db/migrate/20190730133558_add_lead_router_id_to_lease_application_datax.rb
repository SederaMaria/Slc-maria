class AddLeadRouterIdToLeaseApplicationDatax < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_application_dataxes, :leadrouter_lead_id, :integer
  end
end
