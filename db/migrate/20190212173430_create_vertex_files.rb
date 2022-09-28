class CreateVertexFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :vertex_files do |t|
      t.string :filename
      t.date :processed_date

      t.timestamps
    end
  end
end
