class AddExpiredToLeaseApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_applications, :expired,  :boolean, default: false
  end
end
