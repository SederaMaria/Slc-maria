class AddStatesArrayToApplicationSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :application_settings, :enabled_states, :string, limit: 2, array: true
  end
end
