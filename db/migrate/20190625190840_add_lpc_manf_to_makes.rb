class AddLpcManfToMakes < ActiveRecord::Migration[5.1]
  def change
    add_column :makes, :lpc_manf, :string, limit: 10
  end
end
