class RemoveCommonSettingsColumnsFromApplicationSettings < ActiveRecord::Migration[5.1]
  def up
    application_setting = ApplicationSetting.last
    if application_setting.present?
      CommonApplicationSetting.destroy_all
      CommonApplicationSetting.create(
        company_term: application_setting.company_term,
        underwriting_hours: application_setting.underwriting_hours,
        funding_approval_checklist: application_setting.funding_approval_checklist,
        power_of_attorney_template: application_setting.power_of_attorney_template,
        illinois_power_of_attorney_template: application_setting.illinois_power_of_attorney_template)
    end
    
    remove_column :application_settings, :company_term
    remove_column :application_settings, :underwriting_hours
    remove_column :application_settings, :funding_approval_checklist
    remove_column :application_settings, :power_of_attorney_template
    remove_column :application_settings, :illinois_power_of_attorney_template
  end

  def down
    add_column :application_settings, :company_term, :string
    add_column :application_settings, :underwriting_hours, :string
    add_column :application_settings, :funding_approval_checklist, :string
    add_column :application_settings, :power_of_attorney_template, :string
    add_column :application_settings, :illinois_power_of_attorney_template, :string
  end
end
