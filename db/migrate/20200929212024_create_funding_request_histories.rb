class CreateFundingRequestHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :funding_request_histories do |t|
      t.references :lease_application, foreign_key: true
      t.integer :amount_cents
      t.timestamps
    end
  end
end
