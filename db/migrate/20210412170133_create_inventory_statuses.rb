class CreateInventoryStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_statuses do |t|
      t.boolean :active, default: true
      t.string :description
      
      t.timestamps
    end
  end
end
