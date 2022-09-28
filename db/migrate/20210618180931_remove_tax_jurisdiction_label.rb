class RemoveTaxJurisdictionLabel < ActiveRecord::Migration[6.0]
  def change
    remove_column :us_states, :tax_jurisdiction_label, :string
  end
end
