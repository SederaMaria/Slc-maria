class AddSortIndexToMailCarrier < ActiveRecord::Migration[5.1]
  def change
    add_column :mail_carriers, :sort_index, :integer
  end
end
