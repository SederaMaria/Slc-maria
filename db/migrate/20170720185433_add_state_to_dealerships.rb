class AddStateToDealerships < ActiveRecord::Migration[5.0]
  def change
    add_column :dealerships, :state, :string
  end
end
