class ApplicationSetting < ApplicationRecord
  
  attr_writer :residual_reduction_percentage_60, :dealer_participation_sharing_percentage_60

  def residual_reduction_percentage_60
    0.0
  end

  def dealer_participation_sharing_percentage_60
    0.0
  end
end

class AddDefaultSettingsToResidualMultipliers < ActiveRecord::Migration[5.0]
  def change
    #Update Defaults
    change_column_default :model_groups, :residual_reduction_percentage, from: 100.0, to: 0.0
    change_column_default :application_settings, :residual_reduction_percentage_24, from: 0.0, to: 75.0
    change_column_default :application_settings, :residual_reduction_percentage_36, from: 0.0, to: 70.0
    change_column_default :application_settings, :residual_reduction_percentage_48, from: 0.0, to: 65.0

    #Update any previously migrated columns
    ApplicationSetting.update_all.update(residual_reduction_percentage_24: 75.0,
                                               residual_reduction_percentage_36: 70.0,
                                               residual_reduction_percentage_48: 65.0)

    ModelGroup.reset_column_information
    {
      'Street' => 50.0,
      'Sportster' => 65.0,
      'VRSC' => 65.0,
      'Dyna' => 65.0,
      'Softail' => 75.0,
      'Touring' => 75.0,
    }.each do |model_group, percentage|
      ModelGroup.where(name: model_group).update_all(residual_reduction_percentage: percentage)
    end

  end
end