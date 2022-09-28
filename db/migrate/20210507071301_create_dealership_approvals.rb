class CreateDealershipApprovals < ActiveRecord::Migration[6.0]
  def change
    create_table :dealership_approvals do |t|
      t.references :dealership, foreign_key: true, index: true
      t.references :dealership_approval_type, foreign_key: true, index: true
      t.timestamps
    end
  end
end
