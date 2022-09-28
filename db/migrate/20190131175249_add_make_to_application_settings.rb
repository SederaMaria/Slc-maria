class AddMakeToApplicationSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :application_settings, :make_id, :integer
  end
end
