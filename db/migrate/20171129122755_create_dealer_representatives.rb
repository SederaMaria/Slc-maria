class CreateDealerRepresentatives < ActiveRecord::Migration[5.1]
  def change
    create_table :dealer_representatives do |t|
      t.string :name
      t.string :email
      t.references :dealership, foreign_key: true

      t.timestamps
    end
  end
end
