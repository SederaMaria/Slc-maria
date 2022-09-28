class AddUniqueIndexToState < ActiveRecord::Migration[5.1]
  def change
    add_index :states, :abbreviation, unique: true
  end
end