class AddIllinoisPoaToAppSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :application_settings, :illinois_power_of_attorney_template, :string
  end
end
