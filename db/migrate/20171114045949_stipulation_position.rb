class StipulationPosition < ActiveRecord::Migration[5.1]
  def change
    add_column :stipulations, :position, :integer
  end
end
