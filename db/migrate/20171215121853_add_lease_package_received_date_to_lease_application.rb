class AddLeasePackageReceivedDateToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :lease_package_received_date, :datetime
  end
end
