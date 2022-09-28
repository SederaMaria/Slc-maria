class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :addressable_type
      t.integer :addressable_id
      t.index [:addressable_id, :addressable_type]
      t.timestamps
    end
  end
end
