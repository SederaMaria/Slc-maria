class AddUsStateIdToTaxdetails < ActiveRecord::Migration[5.1]
  def change
	add_column :tax_details, :us_state_id, :bigint
	add_column :lpc_form_code_lookups, :us_state_id, :bigint
  end
end
