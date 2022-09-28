class AddCityToAddress < ActiveRecord::Migration[6.0]
  def change
    add_reference :addresses, :city, foreign_key: true
  end
end
