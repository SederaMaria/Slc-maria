class CreateCreditTiers < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_tiers do |t|
      t.integer :position
      t.references :make
      t.string :description
      t.decimal :money_factor, precision: 9, scale: 8
      t.monetize :motorcycle_max_advance
      t.monetize :f_and_i_max_advance
      t.monetize :f_and_i_min_advance
      t.decimal :irr_value, precision: 8, scale: 2
      t.timestamps
    end
  end
end
