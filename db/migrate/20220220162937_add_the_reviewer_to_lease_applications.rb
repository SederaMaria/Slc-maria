class AddTheReviewerToLeaseApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_applications, :the_reviewer, :string
  end
end
