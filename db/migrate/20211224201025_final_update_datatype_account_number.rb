class FinalUpdateDatatypeAccountNumber < ActiveRecord::Migration[6.0]
    def up
        change_column :dealerships, :account_number, :string
    end

    def down
        change_column :dealerships, :account_number, :bigint
    end
end
