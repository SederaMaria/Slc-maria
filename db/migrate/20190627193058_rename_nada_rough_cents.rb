class RenameNadaRoughCents < ActiveRecord::Migration[5.1]
  def change
  	rename_column(:nada_dummy_bikes,:nada_rought_cents,:nada_rough_cents)
  end
end
