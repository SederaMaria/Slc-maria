class AddCountyToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :county, :string
  end
end
