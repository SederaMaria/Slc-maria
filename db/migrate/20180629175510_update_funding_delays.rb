class UpdateFundingDelays < ActiveRecord::Migration[5.1]
  def change
    rename_column :funding_delays, :description, :notes
    remove_column :funding_delays, :applied_on
    change_column :funding_delays, :status, :string, default: 'Required'
  end
end
