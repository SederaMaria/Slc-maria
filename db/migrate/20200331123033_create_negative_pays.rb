class CreateNegativePays < ActiveRecord::Migration[5.1]
  def change
    create_table :negative_pays do |t|
      t.string :payment_bank_name
      t.string :payment_account_type
      t.string :payment_account_number
      t.string :payment_aba_routing_number
      t.string :request
      t.string :response

      t.references :lease_application, foreign_key: true
      t.references :lessee, foreign_key: true

      t.timestamps
    end
  end
end
