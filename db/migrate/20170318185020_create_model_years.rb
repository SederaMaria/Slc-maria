class CreateModelYears < ActiveRecord::Migration[5.0]
  def change
    create_table :model_years do |t|
      t.monetize :original_msrp
      t.monetize :nada_avg_retail
      t.monetize :nada_rough
      t.monetize :subvention
      t.string :name
      t.integer :year
      t.monetize :residual_24
      t.monetize :residual_36
      t.monetize :residual_48

      t.timestamps
    end
  end
end
