class AddGeoCodeStateToUsStates < ActiveRecord::Migration[5.1]
  def up
    add_column :us_states, :geo_code_state, :string, limit: 2
  end

  def down
    remove_column :us_states, :geo_code_state
  end
end
