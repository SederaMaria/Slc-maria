# == Schema Information
#
# Table name: common_application_settings
#
#  id                                  :bigint(8)        not null, primary key
#  company_term                        :string
#  underwriting_hours                  :string
#  funding_approval_checklist          :string
#  power_of_attorney_template          :string
#  illinois_power_of_attorney_template :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deactivate_dealer_participation     :boolean          default(FALSE)
#  require_primary_email_address       :boolean          default(FALSE)
#  scheduling_day                      :integer          default(15)
#  funding_request_form                :string
#

class CommonApplicationSetting < ApplicationRecord
  include ActiveRecord::Singleton
  include SimpleAudit::Model
  simple_audit

  DISPLAY_NAME = 'Common Application Settings'.freeze

  mount_uploader :power_of_attorney_template, PDFUploader
  mount_uploader :illinois_power_of_attorney_template, PDFUploader
  mount_uploader :company_term, PDFUploader
  mount_uploader :funding_approval_checklist, PDFUploader
  mount_uploader :funding_request_form, PDFUploader


  def display_name
   DISPLAY_NAME
  end

  def local_funding_approval_checklist_path
    get_path(funding_approval_checklist)
  end

  def power_of_attorney_template_path
    get_path(power_of_attorney_template)
  end

  def illinois_power_of_attorney_template_path
    get_path(illinois_power_of_attorney_template)
  end

  def funding_request_form_path
    get_path(funding_request_form)
  end

  private 

  def get_path(col)
    if Rails.env.development?
      col.cache_stored_file!
      return col.path
    else
      download = open(col.url)
      filename = col.file.filename
      filepath = "#{Rails.root}/tmp/#{filename}"
      IO.copy_stream(download, filepath) unless File.exists?(filename)
      return filepath
    end
  end
  
end
