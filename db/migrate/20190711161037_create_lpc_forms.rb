class CreateLpcForms < ActiveRecord::Migration[5.1]
  def change
    create_table :lpc_forms do |t|
      t.integer :lpc_form_code_id
      t.string :lpc_form_code_abbrev

      t.timestamps
    end
  end
end
