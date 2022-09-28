class SplitDealerRepresentativeName < ActiveRecord::Migration[5.1]
  def change
    remove_column :dealer_representatives, :name, :string
    add_column :dealer_representatives, :first_name, :string
    add_column :dealer_representatives, :last_name, :string
  end
end
