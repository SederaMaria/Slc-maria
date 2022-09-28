class AddEiNandSecStateToDealerships < ActiveRecord::Migration[6.0]
  def change
    add_column :dealerships, :employer_identification_number, :string, limit: 9
    add_column :dealerships, :secretary_state_valid, :boolean
  end
end
