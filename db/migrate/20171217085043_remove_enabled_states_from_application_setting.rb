class RemoveEnabledStatesFromApplicationSetting < ActiveRecord::Migration[5.1]
  def change
    State.where(abbreviation: ApplicationSetting.instance.enabled_states).update_all(active_on_calculator: true)
    remove_column :application_settings, :enabled_states
  end
end
