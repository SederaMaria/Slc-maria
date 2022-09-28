class RenameActionToRights < ActiveRecord::Migration[6.0]
  def change
    rename_column :actions, :action, :rights
  end
end
