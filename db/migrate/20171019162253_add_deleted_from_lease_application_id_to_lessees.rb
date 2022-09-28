class AddDeletedFromLeaseApplicationIdToLessees < ActiveRecord::Migration[5.1]
  def change
    add_reference :lessees, :deleted_from_lease_application, foreign_key: {to_table: :lease_applications}, index: true
  end
end