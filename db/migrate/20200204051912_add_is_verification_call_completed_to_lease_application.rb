class AddIsVerificationCallCompletedToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :is_verification_call_completed, :boolean, default: false
  end
end
