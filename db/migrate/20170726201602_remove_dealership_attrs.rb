class RemoveDealershipAttrs < ActiveRecord::Migration[5.0]
  def change
    remove_columns :dealerships, :primary_contact, :primary_contact_email
  end
end