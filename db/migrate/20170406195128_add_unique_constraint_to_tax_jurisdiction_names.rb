class AddUniqueConstraintToTaxJurisdictionNames < ActiveRecord::Migration[5.0]
  def change
    add_index :tax_jurisdictions, [:name, :us_state], unique: true
  end
end
