class AddNadaModelGroupNameToModelYear < ActiveRecord::Migration[5.1]
   def change
  	add_column :model_years, :nada_model_group_name, :string
  end
end
