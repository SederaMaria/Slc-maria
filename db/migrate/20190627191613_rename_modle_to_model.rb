class RenameModleToModel < ActiveRecord::Migration[5.1]
  def change
  	rename_column(:nada_dummy_bikes,:modle_group_name,:model_group_name)
  end
end
