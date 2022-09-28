class TaxJurisdictionAddUsStateId < ActiveRecord::Migration[5.1]
  def change
  	add_reference :tax_jurisdictions, :us_states, foreign_key: true
  end
end
