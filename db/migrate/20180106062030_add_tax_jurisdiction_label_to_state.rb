class AddTaxJurisdictionLabelToState < ActiveRecord::Migration[5.1]
  def change
    add_column :states, :tax_jurisdiction_label, :string
  end
end
