class AddCarrierAndTypeToReferencePhone < ActiveRecord::Migration[5.1]
  def change
    add_column :references, :phone_number_line, :string
    add_column :references, :phone_number_carrier, :string
  end
end
