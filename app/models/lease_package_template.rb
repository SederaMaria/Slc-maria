# == Schema Information
#
# Table name: lease_package_templates
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  lease_package_template :string
#  document_type          :integer          not null
#  us_states              :string           default([]), not null, is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  position               :integer
#  enabled                :boolean          default(TRUE), not null
#
# Indexes
#
#  index_lease_package_templates_on_name  (name) UNIQUE
#

class LeasePackageTemplate < ApplicationRecord
  enum document_type: { dealership: 0, customer: 1, title: 2 }

  # The scope option value needs to be in Array format.
  # See https://github.com/swanandp/acts_as_list#notes
  acts_as_list scope: [:document_type]

  validates :document_type, :lease_package_template, presence: true 

  validates_uniqueness_of :name, scope: :document_type, presence: true

  before_validation { |resource| resource.us_states = resource.us_states.reject(&:blank?) } #remove blanks

  mount_uploader :lease_package_template, LeasePackageTemplateUploader #only allows PDF files

  scope :for_state, ->(state_list) { where("#{self.quoted_table_name}.us_states @> ARRAY[:state_list]::varchar[]", state_list: state_list) }
  scope :enabled, -> { where(enabled: true) }

  def local_template_path
    begin  
      if Rails.env.development?
        lease_package_template.cache_stored_file!
        return lease_package_template.path
      else
        download = open(lease_package_template.url)
        filename = lease_package_template.file.filename
        filepath = "#{Rails.root}/tmp/#{filename}"
        IO.copy_stream(download, filepath) unless File.exists?(filename)
        return filepath
      end
    rescue => e
      Rails.logger.info("Errored for pdf template : #{lease_package_template} Exception Details: #{e}")
    end  
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i[for_state]
  end

end

