class AddSortIndexToWelcomeCallType < ActiveRecord::Migration[5.1]
  def change
     add_column :welcome_call_types, :sort_index, :integer
  end
end
