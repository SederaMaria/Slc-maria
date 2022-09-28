class UpdateLesseeSchema < ActiveRecord::Migration[5.0]
  def change
    drop_table :lessees

    create_table :lessees

    add_column :lessees, :first_name, :string
    add_column :lessees, :middle_initial, :string, limit: 1
    add_column :lessees, :last_name, :string
    add_column :lessees, :suffix, :string
    add_column :lessees, :ssn, :string
    add_column :lessees, :date_of_birth, :date
    add_column :lessees, :mobile_phone_number, :string
    add_column :lessees, :home_phone_number, :string
    add_column :lessees, :drivers_license_id_number, :string
    add_column :lessees, :drivers_license_state, :string
    add_column :lessees, :email_address, :string
    add_column :lessees, :employment_details, :string
  end
end
