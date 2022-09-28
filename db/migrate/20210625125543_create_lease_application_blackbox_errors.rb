class CreateLeaseApplicationBlackboxErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_blackbox_errors do |t|
      t.references :lease_application_blackbox_request, foreign_key: true, index: { name: 'index_blackbox_errors_on_blackbox_request_id' }
      t.integer :error_code
      t.string :name
      t.string :message
      t.jsonb :failure_conditional

      t.timestamps
    end
  end
end
