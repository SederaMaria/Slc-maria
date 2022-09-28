class CreateCounties < ActiveRecord::Migration[5.1]
  def change
    create_table :counties do |t|
      t.integer :us_state_id
      t.string :name
      t.string :abbreviation

      t.timestamps
    end
  end
end
