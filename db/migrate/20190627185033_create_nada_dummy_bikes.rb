class CreateNadaDummyBikes < ActiveRecord::Migration[5.1]
  def change
    create_table :nada_dummy_bikes do |t|
      t.string :make
      t.string :year
      t.string :modle_group_name
      t.string :model_name
      t.string :nada_rought_cents

      t.timestamps
    end
  end
end
