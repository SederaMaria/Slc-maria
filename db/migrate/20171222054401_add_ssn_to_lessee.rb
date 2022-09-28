class AddSsnToLessee < ActiveRecord::Migration[5.1]
  def change
    add_column :lessees, :ssn, :text
  end
end
