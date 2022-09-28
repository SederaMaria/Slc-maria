class RemoveColumnMakeFromNadaDummyBikes < ActiveRecord::Migration[5.1]
   def up
  	#remove_column :nada_dummy_bikes, :make
  end

  def down
    #add_column :nada_dummy_bikes, :make, :string
  end
end
