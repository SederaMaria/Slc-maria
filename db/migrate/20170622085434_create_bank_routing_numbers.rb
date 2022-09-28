class CreateBankRoutingNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_routing_numbers do |t|
      t.string :routing_number
      t.string :office_code
      t.string :servicing_frb_number
      t.string :record_type_code
      t.date   :change_date
      t.string :new_routing_number
      t.string :customer_name
      t.string :address
      t.string :city
      t.string :state_code
      t.string :zipcode
      t.string :zipcode_extension
      t.string :telephone_area_code
      t.string :telephone_prefix_number
      t.string :telephone_suffix_number
      t.string :institution_status_code
      t.string :data_view_code
      t.string :filler
      t.timestamps
    end
  end
end
