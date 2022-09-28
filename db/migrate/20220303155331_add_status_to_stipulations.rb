class AddStatusToStipulations < ActiveRecord::Migration[6.0]
  def change
    add_column :stipulations, :active, :boolean, default: true, null: false
  end
end
