class AddPrenoteStatusToPrenote < ActiveRecord::Migration[5.1]
  def change
    add_column :prenotes, :prenote_status, :string
  end
end
