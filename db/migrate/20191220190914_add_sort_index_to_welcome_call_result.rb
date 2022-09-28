class AddSortIndexToWelcomeCallResult < ActiveRecord::Migration[5.1]
  def change
    add_column :welcome_call_results, :sort_index, :integer
  end
end
