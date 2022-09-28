class CreateReference < ActiveRecord::Migration[5.0]
  def change
    create_table :references do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.timestamps
    end
  end
end
