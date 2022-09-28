class AddSubmittedAtToLeaseApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_applications, :submitted_at, :datetime
  end
end
