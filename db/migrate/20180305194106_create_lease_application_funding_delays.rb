class CreateLeaseApplicationFundingDelays < ActiveRecord::Migration[5.1]
  def change
    create_table :lease_application_funding_delays do |t|
      t.references :lease_application, foreign_key: true, index: {name: 'lease_application_id_idx'}
      t.references :funding_delay_reason, foreign_key: true, index: {name: 'funding_delay_reason_idx' }
      t.text :description
      t.date :applied_on
      t.integer :status

      t.timestamps
    end
    add_index :lease_application_funding_delays, [:lease_application_id, :funding_delay_reason_id], unique: true, name: 'lease_application_funding_delays_unique_index'
  end
end
