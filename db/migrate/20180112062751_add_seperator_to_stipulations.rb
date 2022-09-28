class AddSeperatorToStipulations < ActiveRecord::Migration[5.1]
  def change
    add_column :stipulations, :separator, :string, default: '-'
  end
end
