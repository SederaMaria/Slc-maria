class AddLeaseApplicationsToReferences < ActiveRecord::Migration[5.0]
  def change
    add_reference :references, :lease_application, foreign_key: true, index: true
  end
end
