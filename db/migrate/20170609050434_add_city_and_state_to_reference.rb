class AddCityAndStateToReference < ActiveRecord::Migration[5.0]
  def change
    add_column :references, :city,  :string
    add_column :references, :state, :string
  end
end
