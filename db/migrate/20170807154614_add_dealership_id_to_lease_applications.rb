class AddDealershipIdToLeaseApplications < ActiveRecord::Migration[5.0]
  def up
    add_reference :lease_applications, :dealership, foreign_key: true
    LeaseApplication.reset_column_information
    LeaseApplication.where.not(dealer_id: nil).each do |la|
      la.update(dealership_id: la.dealer.dealership_id)
    end
    #change_column_null :lease_applications, :dealership_id, false
  end

  def down
    remove_reference :lease_applications, :dealership
  end
end
