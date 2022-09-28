class CreateDealerships < ActiveRecord::Migration[5.0]
  def change
    create_table :dealerships do |t|
      t.string :name
      t.string :website
      t.string :primary_contact
      t.string :primary_contact_email
      t.string :primary_contact_phone
      t.timestamps
    end
  end
end
