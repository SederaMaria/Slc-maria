class AddAccountHolderToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :payment_account_holder, :string
  end
end
