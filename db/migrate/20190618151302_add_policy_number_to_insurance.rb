class AddPolicyNumberToInsurance < ActiveRecord::Migration[5.1]
  def change
    add_column :insurances, :policy_number, :string
  end
end
