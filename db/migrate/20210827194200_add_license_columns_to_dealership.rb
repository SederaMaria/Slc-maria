class AddLicenseColumnsToDealership < ActiveRecord::Migration[6.0]
  def change
    add_column :dealerships, :dealer_license_number, :string
    add_column :dealerships, :license_expiration_date, :date
    add_column :dealerships, :pct_ownership, :decimal, precision: 30, scale: 2
  end
end
