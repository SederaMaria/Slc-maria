class CreateUsioReturnCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :usio_return_codes do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
