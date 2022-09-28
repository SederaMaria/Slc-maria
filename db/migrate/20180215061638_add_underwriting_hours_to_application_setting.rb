class AddUnderwritingHoursToApplicationSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :application_settings, :underwriting_hours, :string
  end
end
