class CreateLeaseApplicationDataxes < ActiveRecord::Migration[5.1]
  def change
    create_table :lease_application_dataxes do |t|
      t.integer :lease_application_id
      t.string :leadrouter_response
      t.float :leadrouter_credit_score
      t.string :leadrouter_suggested_corrections

      t.timestamps
    end
  end
end
