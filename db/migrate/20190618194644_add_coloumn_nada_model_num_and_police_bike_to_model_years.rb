class AddColoumnNadaModelNumAndPoliceBikeToModelYears < ActiveRecord::Migration[5.1]
  def change
  	add_column :model_years, :nada_model_number, :string
  	add_column :model_years, :police_bike, :boolean, null: false, default: false
  end
end
