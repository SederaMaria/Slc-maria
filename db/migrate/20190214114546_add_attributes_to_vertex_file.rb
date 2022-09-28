class AddAttributesToVertexFile < ActiveRecord::Migration[5.1]
  def change
    add_column :vertex_files, :last_changed_date, :string
    add_column :vertex_files, :update_number, :string
  end
end
