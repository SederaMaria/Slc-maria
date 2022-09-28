class RenameDataXToBlackboxRequest < ActiveRecord::Migration[6.0]
  def change
    rename_table :lease_application_dataxes, :lease_application_blackbox_requests
  end
end
