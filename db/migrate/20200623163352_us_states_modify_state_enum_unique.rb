class UsStatesModifyStateEnumUnique < ActiveRecord::Migration[5.1]
  def change
  	add_index :us_states, :state_enum, unique: true
  end
end
