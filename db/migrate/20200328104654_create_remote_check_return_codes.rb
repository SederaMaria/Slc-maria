class CreateRemoteCheckReturnCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :remote_check_return_codes do |t|
      t.string :code
      t.text :description

      t.timestamps
    end
    add_index :remote_check_return_codes, :code
  end
end
