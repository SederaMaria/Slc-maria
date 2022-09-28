class CreateLeaseApplicationDataxRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :lease_application_datax_requests do |t|
      t.integer :lease_application_id
      t.string :leadrouter_request_body
      t.string :leadrouter_response

      t.timestamps
    end
  end
end
