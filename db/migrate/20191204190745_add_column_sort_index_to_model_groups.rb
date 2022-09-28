class AddColumnSortIndexToModelGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :model_groups, :sort_index, :integer
  end
end
