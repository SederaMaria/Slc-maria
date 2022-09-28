class CreateLeaseApplicationBlackboxTloPersonSearchAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_blackbox_tlo_person_search_addresses do |t|
      t.date :date_first_seen
      t.date :date_last_seen
      t.string :street_address_1
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :county
      t.string :zip_plus_four
      t.string :building_name
      t.string :description
      t.string :subdivision_name
      t.references :lease_application_blackbox_request, foreign_key: true, index: {name: 'blackbox_tlo_person_search_addresses_req'}
      t.timestamps
    end
  end
end
