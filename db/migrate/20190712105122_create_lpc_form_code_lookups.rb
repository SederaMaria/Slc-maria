class CreateLpcFormCodeLookups < ActiveRecord::Migration[5.1]
  def change
    create_table :lpc_form_code_lookups do |t|
      t.integer :state_id
      t.integer :lpc_form_code_id
      t.string :lpc_description

      t.timestamps
    end
  end
end
