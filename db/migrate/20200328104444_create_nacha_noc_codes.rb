class CreateNachaNocCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nacha_noc_codes do |t|
      t.string :code
      t.text :description

      t.timestamps
    end
    add_index :nacha_noc_codes, :code
  end
end
