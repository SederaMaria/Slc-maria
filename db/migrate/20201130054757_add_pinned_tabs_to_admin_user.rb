class AddPinnedTabsToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :pinned_tabs, :string
  end
end
