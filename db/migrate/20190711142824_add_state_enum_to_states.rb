class AddStateEnumToStates < ActiveRecord::Migration[5.1]
  def change
    add_column :states, :state_enum, :integer
  end
end
