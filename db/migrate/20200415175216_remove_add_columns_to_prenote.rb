class RemoveAddColumnsToPrenote < ActiveRecord::Migration[5.1]
  def up
    remove_column :prenotes, :status
    remove_column :prenotes, :result

    add_column :prenotes, :usio_confirmation_number, :string
    add_column :prenotes, :usio_status, :string
    add_column :prenotes, :usio_message, :string
  end

  def down
    add_column :prenotes, :status, :string
    add_column :prenotes, :result, :string

    remove_column :prenotes, :usio_confirmation_number, :string
    remove_column :prenotes, :usio_status, :string
    remove_column :prenotes, :usio_message, :string
  end
end
