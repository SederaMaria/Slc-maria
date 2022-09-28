class AddTimestampsToAppSettings < ActiveRecord::Migration[5.0]
  def change
    change_table :application_settings do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end

    ApplicationSetting.reset_column_information

    ApplicationSetting.update_all(created_at: Time.zone.now, updated_at: Time.zone.now)

    change_column :application_settings, :created_at, :datetime, null: false
    change_column :application_settings, :updated_at, :datetime, null: false

  end
end
