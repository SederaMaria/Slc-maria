class AddRedmitToDealerToDealership < ActiveRecord::Migration[6.0]
  def change
    add_reference :dealerships, :remit_to_dealer_calculation, foreign_key: true, index: true
  end
end
