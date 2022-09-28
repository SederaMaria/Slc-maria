class AddForeignKeyConstraintsToLeaseApps < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key(:lease_applications, :dealers)
    add_foreign_key(:lease_applications, :lease_calculators)
  end
end
