class AddUsioTransactionResponseToPrenotes < ActiveRecord::Migration[5.1]
  def change
    add_column :prenotes, :usio_transaction_response, :jsonb, :null => false, :default => {}
  end
end
