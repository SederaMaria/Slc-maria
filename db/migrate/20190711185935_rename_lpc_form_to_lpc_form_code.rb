class RenameLpcFormToLpcFormCode < ActiveRecord::Migration[5.1]
  def change
    rename_table :lpc_forms, :lpc_form_codes
  end
end
