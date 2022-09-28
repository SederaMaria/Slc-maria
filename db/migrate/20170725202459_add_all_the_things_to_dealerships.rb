class AddAllTheThingsToDealerships < ActiveRecord::Migration[5.0]
  def change
    change_table :dealerships do |t|
      t.boolean :franchised
      t.boolean :franchised_new_makes
      t.string :legal_corporate_entity
      t.string :dealer_group
      t.boolean :active
      t.references :address, foreign_key: true
      t.date   :agreement_signed_on
      t.string :executed_by_name
      t.string :executed_by_title
      t.date   :executed_by_slc_on
      t.date   :los_access_date
      t.text   :notes
    end
  end
end
