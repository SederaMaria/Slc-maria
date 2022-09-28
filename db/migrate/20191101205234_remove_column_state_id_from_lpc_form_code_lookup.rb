class RemoveColumnStateIdFromLpcFormCodeLookup < ActiveRecord::Migration[5.1]
  def change
  	remove_column :lpc_form_code_lookups, :state_id, :integer
	remove_column :tax_details, :state_id, :integer
	drop_table :states
  end
end