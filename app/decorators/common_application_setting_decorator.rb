class CommonApplicationSettingDecorator < Draper::Decorator
  decorates :common_application_setting
  delegate_all

  def underwriting_hours
    object.underwriting_hours || ''
  end

  def funding_approval_checklist_filename
    object.funding_approval_checklist&.file&.filename
  end

  def funding_approval_checklist_url
    object.funding_approval_checklist&.url
  end

  def has_funding_approval_checklist?
    object.funding_approval_checklist.present?
  end

  def power_of_attorney_template_filename
    object.power_of_attorney_template&.file&.filename
  end

  def power_of_attorney_template_url
    object.power_of_attorney_template&.url
  end

  def has_power_of_attorney_template?
    object.power_of_attorney_template.present?
  end

  def illinois_power_of_attorney_template_filename
    object.illinois_power_of_attorney_template&.file&.filename
  end

  def illinois_power_of_attorney_template_url
    object.illinois_power_of_attorney_template&.url
  end

  def has_illinois_power_of_attorney_template?
    object.illinois_power_of_attorney_template.present?
  end

  def funding_request_form_filename
    object.funding_request_form&.file&.filename
  end

  def funding_request_form_url
    object.funding_request_form&.url
  end

  def has_funding_request_form?
    object.funding_request_form.present?
  end

  def filename
    object&.company_term&.file&.filename
  end

  def file_url
    object&.company_term&.url
  end

  def has_company_term?
    object.company_term.present?
  end

  def no_file?
    !has_file?
  end
end
