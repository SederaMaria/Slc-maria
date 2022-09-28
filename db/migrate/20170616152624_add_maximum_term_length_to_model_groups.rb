class AddMaximumTermLengthToModelGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :model_groups, :maximum_term_length, :integer, default: 60, null: false
  end
end
