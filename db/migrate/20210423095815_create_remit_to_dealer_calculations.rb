class CreateRemitToDealerCalculations < ActiveRecord::Migration[6.0]
  def change
    create_table :remit_to_dealer_calculations do |t|
      t.string :calculation_name 
      t.string :description 
      t.timestamps
    end
  end
end
