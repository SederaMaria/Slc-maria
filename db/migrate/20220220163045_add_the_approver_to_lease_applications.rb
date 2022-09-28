class AddTheApproverToLeaseApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_applications, :the_approver, :string
  end
end
