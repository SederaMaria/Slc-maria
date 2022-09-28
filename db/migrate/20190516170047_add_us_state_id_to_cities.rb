class AddUsStateIdToCities < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :us_state_id, :integer
  end
end
