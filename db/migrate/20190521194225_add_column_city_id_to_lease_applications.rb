class AddColumnCityIdToLeaseApplications < ActiveRecord::Migration[5.1]
  def change
    add_reference :lease_applications, :city, foreign_key: true
  end
end
