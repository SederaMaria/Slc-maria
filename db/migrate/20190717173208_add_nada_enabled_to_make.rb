class AddNadaEnabledToMake < ActiveRecord::Migration[5.1]
  def change
  	add_column :makes, :nada_enabled, :boolean, :default => false
  end
end
