class AddWelcomeCallDueDateToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :welcome_call_due_date, :datetime
  end
end
