class AddLeasEAppIdPartialIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :lease_applications, :application_identifier, unique: true, where: "application_identifier IS NOT NULL"
  end
end
