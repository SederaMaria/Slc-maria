class AddCreditStatusToLeaseApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_applications, :credit_status, :string
  end
end
