class AddUniqueIndexToLeaseApplicationStipulations < ActiveRecord::Migration[5.1]
  def change
    add_index :lease_application_stipulations, [:lease_application_id, :stipulation_id], unique: true, name: 'index_lease_application_stipulations_uniqueness'
  end
end
