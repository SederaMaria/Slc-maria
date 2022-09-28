class RemoveChangeMiddleInitialToMiddleName < ActiveRecord::Migration[5.0]
  def up
    change_column(:lessees, :middle_initial, :string, limit: nil)
    rename_column(:lessees, :middle_initial, :middle_name)
  end

  def down
    rename_column(:lessees, :middle_name, :middle_initial)
    change_column(:lessees, :middle_initial, :string, limit: 1)
  end
end
