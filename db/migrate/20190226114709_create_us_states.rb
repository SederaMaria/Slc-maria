class CreateUsStates < ActiveRecord::Migration[5.1]
  def change
    create_table :us_states do |t|
      t.string :name
      t.string :abbreviation
      t.boolean :sum_of_payments_state
      t.boolean :active_on_calculator
      t.string :tax_jurisdiction_label

      t.timestamps
    end
  end
end
