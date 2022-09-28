class UpdateLeadRouterIdToBigint < ActiveRecord::Migration[6.0]
  def up
    rename_column :lease_application_dataxes, :leadrouter_lead_id, :leadrouter_lead_id_int
    add_column :lease_application_dataxes, :leadrouter_lead_id, :uuid
  end

  def down
      remove_column :lease_application_dataxes, :leadrouter_lead_id
      rename_column :lease_application_dataxes, :leadrouter_lead_id_int, :leadrouter_lead_id
  end
end
