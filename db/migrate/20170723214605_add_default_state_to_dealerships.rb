class AddDefaultStateToDealerships < ActiveRecord::Migration[5.0]
  def change
    change_column_default :dealerships, :state, 'FL'
    Dealership.where(state: nil).update_all(state: 'FL')
    change_column_null :dealerships, :state, false
  end
end
