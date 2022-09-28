class ChangeEnabledStatesDefaultToEmptyArray < ActiveRecord::Migration[5.1]
  def change
    change_column_default :application_settings, :enabled_states, from: nil, to: []
    ApplicationSetting.reset_column_information
    ApplicationSetting.instance.update(enabled_states: [])
    change_column_null :application_settings, :enabled_states, false
  end
end
