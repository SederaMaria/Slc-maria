class CreateDealershipApprovalTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :dealership_approval_types do |t|
      t.string :description
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
