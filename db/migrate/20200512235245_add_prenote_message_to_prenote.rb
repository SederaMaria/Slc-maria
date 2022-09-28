class AddPrenoteMessageToPrenote < ActiveRecord::Migration[5.1]
  def change
    add_column :prenotes, :prenote_message, :string
  end
end
