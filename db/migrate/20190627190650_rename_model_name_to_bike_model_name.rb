class RenameModelNameToBikeModelName < ActiveRecord::Migration[5.1]
  def change
  	rename_column(:nada_dummy_bikes,:model_name,:bike_model_name)
  end
end
