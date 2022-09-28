class CreateLeaseApplicationWelcomeCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :lease_application_welcome_calls do |t|
      t.integer :lease_application_id
      t.integer :welcome_call_result_id
      t.integer :welcome_call_type_id
      t.integer :welcome_call_status_id
      t.integer :welcome_call_representative_type_id
      t.integer :representative_id
      t.datetime :due_date
      t.string :notes

      t.timestamps
    end
  end
end