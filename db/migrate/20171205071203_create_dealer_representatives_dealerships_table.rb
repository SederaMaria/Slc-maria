class CreateDealerRepresentativesDealershipsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :dealer_representatives_dealerships do |t|
      t.integer :dealership_id
      t.integer :dealer_representative_id
    end
  end
end