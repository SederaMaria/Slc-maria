# == Schema Information
#
# Table name: lessees
#
#  id                                :integer          not null, primary key
#  first_name                        :string
#  middle_name                       :string
#  last_name                         :string
#  suffix                            :string
#  encrypted_ssn                     :string
#  date_of_birth                     :date
#  mobile_phone_number               :string
#  home_phone_number                 :string
#  drivers_license_id_number         :string
#  drivers_license_state             :string
#  email_address                     :string
#  employment_details                :string
#  home_address_id                   :integer
#  mailing_address_id                :integer
#  employment_address_id             :integer
#  encrypted_ssn_iv                  :string
#  at_address_years                  :integer
#  at_address_months                 :integer
#  monthly_mortgage                  :decimal(, )
#  home_ownership                    :integer
#  drivers_licence_expires_at        :date
#  employer_name                     :string
#  time_at_employer_years            :integer
#  time_at_employer_months           :integer
#  job_title                         :string
#  employment_status                 :integer
#  employer_phone_number             :string
#  gross_monthly_income              :decimal(, )
#  other_monthly_income              :decimal(, )
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  highest_fico_score                :integer
#  deleted_from_lease_application_id :bigint(8)
#  mobile_phone_number_line          :string
#  mobile_phone_number_carrier       :string
#  home_phone_number_line            :string
#  home_phone_number_carrier         :string
#  employer_phone_number_line        :string
#  employer_phone_number_carrier     :string
#  ssn                               :text
#  proven_monthly_income             :decimal(, )
#
# Indexes
#
#  index_lessees_on_deleted_from_lease_application_id  (deleted_from_lease_application_id)
#  index_lessees_on_employment_address_id              (employment_address_id)
#  index_lessees_on_home_address_id                    (home_address_id)
#  index_lessees_on_mailing_address_id                 (mailing_address_id)
#
# Foreign Keys
#
#  fk_rails_...  (deleted_from_lease_application_id => lease_applications.id)
#

class Lessee < ApplicationRecord
  include Lessees::LeasePackageDocumentMethods
  include SimpleAudit::Model
  simple_audit child: true
  include SimpleAudit::Custom::Lessee

  before_validation :upcase_attributes
  after_save :update_related_applications

  has_one :lease_application, 
    ->(lessee) { 
      unscope(:where).
      where("#{self.quoted_table_name}.lessee_id = :id OR #{self.quoted_table_name}.colessee_id = :id", id: lessee.id)
    }

  has_one :email_validation, foreign_key: 'validatable_id', dependent: :destroy
  has_one :home_phone_validation, foreign_key: 'validatable_id', dependent: :destroy
  has_one :employer_phone_validation, foreign_key: 'validatable_id', dependent: :destroy
  has_one :mobile_phone_validation, foreign_key: 'validatable_id', dependent: :destroy
  has_many :credit_reports
  has_many :recommended_credit_tiers
  has_many :lease_application_blackbox_requests
  has_many :income_verifications
  belongs_to :relationship_to_lessee


  has_many :lease_application_attachments

  has_one :dealership,
    through: :lease_application

  # has_one :employment_status_definition, foreign_key: "definition", :primary_key => 'employment_status', :class_name => "EmploymentStatus"
  has_one :employment_status_definition, foreign_key: "employment_status_index", :primary_key => 'employment_status', :class_name => "EmploymentStatus"
  has_many :income_verifications

  validate :must_be_adult

  with_options dependent: :destroy, class_name: 'Address' do |assoc|
    assoc.belongs_to :home_address
    assoc.belongs_to :mailing_address
    assoc.belongs_to :employment_address
  end

  scope :valid_lessee, -> { where.not(first_name: [nil, ''], ssn: [nil, '']) }
  scope :invalid_lessee, -> { missing_first_name.or(missing_ssn) }
  scope :missing_first_name, -> { where(first_name: [nil, '']) }
  
  #this can't check for a blank ssn value since blank string is in and of itself encrypted.
  #blank ssns or wrong length ssns will have to be checked in callbacks only.
  scope :missing_ssn, -> { where(ssn: nil) }
  scope :by_ssn, -> (query)do
    where.not(ssn: '').search_by_plaintext(:ssn, query)
  end
  scope :by_lease_application_dealership, ->(dealership_id){ where(id: Lessee.joins("JOIN lease_applications AS la on lessees.id = la.lessee_id WHERE (la.dealership_id = #{dealership_id})").pluck(:id) )   }
  scope :by_name, -> (name){ valid_lessee.where("first_name LIKE ? OR last_name LIKE ?", "%#{name}%", "%#{name}%") }
  scope :by_full_name, -> (name){ valid_lessee.where("first_name LIKE ? AND last_name LIKE ?", "%#{name[0]}%", "%#{name[1]}%") }
  scope :by_first_name, -> (name){ valid_lessee.where("first_name LIKE ?", "%#{name}%") }
  scope :by_last_name, -> (name){ valid_lessee.where("last_name LIKE ?", "%#{name}%") }
  scope :by_date_of_birth, -> (date_of_birth){ valid_lessee.where("date_of_birth =  ?", "%#{date_of_birth}%") }

  enum home_ownership: %i(own rent other)
  # enum employment_status: %i(employed self_employed soc_sec unemployed disabled retired)

  #See http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html for configuration options
  accepts_nested_attributes_for :home_address, :mailing_address, :employment_address,
    reject_if: :all_blank

  # attribute :ssn
  attr_encrypted :ed_ssn, :key => ENV['SSN_ENCRYPTION_KEY'], prefix: 'encrypt'
  crypt_keeper :ssn, encryptor: :postgres_pgp, key: ENV['SSN_ENCRYPTION_KEY'], salt: ENV['SSN_ENCRYPTION_SALT']

  # after_update :update_payment_limit_stipulation, if: :saved_change_to_proven_monthly_income?

  def update_related_applications
    DetectRelatedApplicationsJob.perform_async(self.lease_application&.id)
  end

  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end


  def name
    "#{first_name} #{last_name}".squish
  end
  alias_method :full_name, :name

  def name_with_middle_initial
    "#{first_name} #{middle_name} #{last_name} #{suffix}".squish
  end
  alias_method :full_name_with_middle_initial, :name_with_middle_initial

  def county
    home_address&.county || ''
  end

  def last_successful_credit_report
    credit_reports.where(status: 'success').last
  end

  def must_be_adult
    if first_name.present? && date_of_birth.present? && date_of_birth > 18.years.ago.to_datetime
      errors.add(:date_of_birth, 'must be 18 years old')
    end
  end

  def update_carrier(field_name, carrier_data)
    send("#{field_name}_line=", carrier_data['type'])
    send("#{field_name}_carrier=", carrier_data['name'])
    save
  end

  ### Sometimes Accepts Nested Attributes gets confused or a
  # Dealer fills out a Colessee then instead of removing them, will just erase all the data.
  # This checks for blank lessee records and returns true if all the important
  # attributes are blank.
  def blank_record?
    attributes.
      except("id", "ssn", "created_at", "updated_at").
      all?{|k,v| v.blank?} &&
    ssn.blank?
  end

  def not_blank_record?
    !blank_record?
  end
  
  def form_code
    spaces = ["    ", "   ", "  ", " ", ""]
    (state_by_abbrev.nil? ? "" : state_by_abbrev&.lpc_form_code_lookup&.lpc_form_code_id&.to_s&.prepend(spaces[state_by_abbrev&.lpc_form_code_lookup&.lpc_form_code_id&.to_s&.split&.size]))
  end

  def late_charge_asmt
    state_by_abbrev&.lpc_form_code_lookup&.lpc_form_code&.lpc_form_code_abbrev
  end
  

  def get_stipulation_payment_limits_notes
    #maximum payment percentage
    payment_limit_percentage = self.lease_application&.lease_calculator&.credit_tier_v2&.payment_limit_percentage.to_f / 100
    proven_monthly_income = self&.lease_application&.lessee&.proven_monthly_income.to_f + self&.lease_application&.colessee&.proven_monthly_income.to_f
    ActionController::Base.helpers.number_to_currency(proven_monthly_income * payment_limit_percentage)
  end

  private
  
  def state_by_abbrev
    UsState.find_by(abbreviation: self.home_address.state)
  end
  
  def upcase_attributes
    self.first_name = first_name&.upcase
    self.middle_name = middle_name&.upcase
    self.last_name = last_name&.upcase
    self.suffix = suffix&.upcase
    self.drivers_license_state = drivers_license_state&.upcase
    self.employment_details = employment_details&.upcase
    self.employer_name = employer_name&.upcase
    self.job_title = job_title&.upcase
    self.home_phone_number_line = home_phone_number_line&.upcase
    self.home_phone_number_carrier = home_phone_number_carrier&.upcase
    self.mobile_phone_number_line = mobile_phone_number_line&.upcase
    self.mobile_phone_number_carrier = mobile_phone_number_carrier&.upcase
    self.employer_phone_number_line = employer_phone_number_line&.upcase
    self.employer_phone_number_carrier = employer_phone_number_carrier&.upcase
  end

  def update_payment_limit_stipulation
    unless self.lease_application.nil? && self.proven_monthly_income.nil?
      pre_income_stipulation_id = Stipulation.find_by(pre_income_stipulation: true).id
      post_income_stipulation_id = Stipulation.find_by(post_income_stipulation: true).id
      stipulation_ids = self.lease_application.lease_application_stipulations.pluck(:stipulation_id)
      if stipulation_ids.include?(pre_income_stipulation_id)
        stipulation = self.lease_application.lease_application_stipulations.find{ |s| s.stipulation_id == pre_income_stipulation_id }
        stipulation.status = 'Cleared'
        stipulation.save
      end
      if stipulation_ids.include?(post_income_stipulation_id)
        stipulation = self.lease_application.lease_application_stipulations.find{ |s| s.stipulation_id == post_income_stipulation_id }
        stipulation.status = 'Required'
        stipulation.notes = "Limit #{get_stipulation_payment_limits_notes}"
        stipulation.monthly_payment_limit = get_stipulation_payment_limits_notes
        stipulation.save
      else
        self.lease_application.lease_application_stipulations.create(
          stipulation_id: post_income_stipulation_id, 
          status: 'Required', 
          notes: "Limit #{get_stipulation_payment_limits_notes}",
          monthly_payment_limit: get_stipulation_payment_limits_notes
        )
      end
    end
  end


end
