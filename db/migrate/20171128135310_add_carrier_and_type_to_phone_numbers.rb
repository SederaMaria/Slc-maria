class AddCarrierAndTypeToPhoneNumbers < ActiveRecord::Migration[5.1]
  def change
    add_column :lessees, :mobile_phone_number_line, :string
    add_column :lessees, :mobile_phone_number_carrier, :string
    add_column :lessees, :home_phone_number_line, :string
    add_column :lessees, :home_phone_number_carrier, :string
    add_column :lessees, :employer_phone_number_line, :string
    add_column :lessees, :employer_phone_number_carrier, :string
  end
end
