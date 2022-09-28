class AddCanSubmitAppToDealership < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :can_submit, :boolean, default: false
  end
end
