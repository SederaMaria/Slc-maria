class CreateTaxJurisdictons < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_jurisdictions do |t|
      t.string :name
      t.integer :us_state
      t.integer :state_tax_rule_id
      t.integer :county_tax_rule_id
      t.integer :local_tax_rule_id
      t.index [:local_tax_rule_id, :county_tax_rule_id, :state_tax_rule_id, :us_state], name: "index_jurisdiction_on_most_to_least_specific_region"
      t.timestamps
    end
  end
end
