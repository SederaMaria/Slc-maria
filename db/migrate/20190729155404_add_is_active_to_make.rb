class AddIsActiveToMake < ActiveRecord::Migration[5.1]
  def change
    add_column :makes, :active, :boolean, default: true
  end
end
