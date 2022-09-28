class DefaultStateTaxJurisdictionLabels < ActiveRecord::Migration[5.1]
  def change
    State.update_all(tax_jurisdiction_label: 'Customer\'s County/Town')
  end
end
