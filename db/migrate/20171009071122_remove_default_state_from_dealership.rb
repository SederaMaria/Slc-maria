class RemoveDefaultStateFromDealership < ActiveRecord::Migration[5.0]
  def change
    change_column_default :dealerships, :state, nil
  end
end
