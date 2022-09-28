class AddIsActiveToDealerRepresentative < ActiveRecord::Migration[5.1]
  def change
    add_column :dealer_representatives, :is_active, :boolean, default: true
  end
end
