class AddColoumnNadaVolumeNumberToModelYears < ActiveRecord::Migration[5.1]
  def change
    add_column :model_years, :nada_volume_number, :string
  end
end
