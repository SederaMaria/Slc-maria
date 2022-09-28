# == Schema Information
#
# Table name: application_settings
#
#  id                                         :integer          not null, primary key
#  high_model_year                            :integer          default(2017), not null
#  low_model_year                             :integer          default(2007), not null
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  acquisition_fee_cents                      :integer          default(59500), not null
#  dealer_participation_sharing_percentage_24 :decimal(, )      default(50.0), not null
#  base_servicing_fee_cents                   :integer          default(500), not null
#  dealer_participation_sharing_percentage_36 :decimal(, )      default(0.0), not null
#  dealer_participation_sharing_percentage_48 :decimal(, )      default(0.0), not null
#  residual_reduction_percentage_24           :decimal(, )      default(75.0), not null
#  residual_reduction_percentage_36           :decimal(, )      default(70.0), not null
#  residual_reduction_percentage_48           :decimal(, )      default(65.0), not null
#  residual_reduction_percentage_60           :decimal(, )      default(65.0), not null
#  dealer_participation_sharing_percentage_60 :decimal(, )      default(0.0), not null
#  global_security_deposit                    :integer          default(0)
#  enable_global_security_deposit             :boolean          default(FALSE)
#  make_id                                    :integer
#

class ApplicationSetting < ApplicationRecord

  # mount_uploader :power_of_attorney_template, PDFUploader
  # mount_uploader :illinois_power_of_attorney_template, PDFUploader
  # mount_uploader :company_term, PDFUploader
  # mount_uploader :funding_approval_checklist, PDFUploader


  belongs_to :make
  DISPLAY_NAME = 'Finance Settings'.freeze

  validates :make_id, uniqueness: { message: "has already been taken."}
  validates :low_model_year, inclusion: { in: 1900..2100 }, presence: true
  validates :high_model_year, inclusion: { in: 1900..2100 }, presence: true
  validates :dealer_participation_sharing_percentage_24, 
            :dealer_participation_sharing_percentage_36, 
            :dealer_participation_sharing_percentage_48,
            :dealer_participation_sharing_percentage_60,
            :residual_reduction_percentage_24, 
            :residual_reduction_percentage_36, 
            :residual_reduction_percentage_48,
            :residual_reduction_percentage_60,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end

  def display_name
    DISPLAY_NAME
  end

  #This Returns an Enumerator object, not actually a Range!
  def model_year_range_descending #for calculator.  Counts down!
    high_model_year.downto(low_model_year)
  end

  def model_year_range
    model_year_range_descending
  end
  deprecate :model_year_range

  def model_year_range_ascending
    Range.new(low_model_year, high_model_year)
  end

  def local_funding_approval_checklist_path
    get_path(funding_approval_checklist)
  end

  # def power_of_attorney_template_path
  #   get_path(power_of_attorney_template)
  # end

  # def illinois_power_of_attorney_template_path
  #   get_path(illinois_power_of_attorney_template)
  # end

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
