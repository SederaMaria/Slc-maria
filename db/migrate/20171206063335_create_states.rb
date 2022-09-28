class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :name, null: false
      t.string :abbreviation, null: false
      t.boolean :sum_of_payments_state, default: false
    end
  end
end
