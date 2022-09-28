class AddScheduledDayToCommonApplicationSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :common_application_settings, :scheduling_day, :integer, default: 15
  end
end
