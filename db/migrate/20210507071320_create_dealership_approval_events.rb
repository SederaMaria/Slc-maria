class CreateDealershipApprovalEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :dealership_approval_events do |t|
      t.boolean :approved, default: false
      t.references :admin_user, foreign_key: true, index: true
      t.references :dealership_approval, foreign_key: true, index: true
      t.timestamps
    end
  end
end
