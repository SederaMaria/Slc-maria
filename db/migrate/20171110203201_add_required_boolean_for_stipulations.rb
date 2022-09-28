class AddRequiredBooleanForStipulations < ActiveRecord::Migration[5.1]
  def change
    add_column :stipulations, :required, :boolean, default: false
  end
end
