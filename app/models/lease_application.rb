# == Schema Information
#
# Table name: lease_applications
#
#  id                                         :integer          not null, primary key
#  lessee_id                                  :integer
#  colessee_id                                :integer
#  dealer_id                                  :integer
#  lease_calculator_id                        :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  document_status                            :string           default("no_documents"), not null
#  credit_status                              :string           default("unsubmitted"), not null
#  submitted_at                               :date
#  expired                                    :boolean          default(FALSE)
#  application_identifier                     :string
#  documents_issued_date                      :date
#  dealership_id                              :integer
#  lease_package_received_date                :datetime
#  credit_decision_date                       :datetime
#  funding_delay_on                           :date
#  funding_approved_on                        :date
#  funded_on                                  :date
#  first_payment_date                         :date
#  payment_aba_routing_number                 :string
#  payment_account_number                     :string
#  payment_bank_name                          :string
#  payment_account_type                       :integer          default(NULL)
#  payment_frequency                          :integer
#  payment_first_day                          :integer
#  payment_second_day                         :integer
#  second_payment_date                        :date
#  promotion_name                             :string
#  promotion_value                            :float
#  is_dealership_subject_to_clawback          :boolean          default(FALSE)
#  this_deal_dealership_clawback_amount       :decimal(30, 2)
#  after_this_deal_dealership_clawback_amount :decimal(30, 2)
#  city_id                                    :bigint(8)
#  vehicle_possession                         :string
#  payment_account_holder                     :string
#  welcome_call_due_date                      :datetime
#  department_id                              :bigint(8)
#  is_verification_call_completed             :boolean          default(FALSE)
#  is_exported_to_access_db                   :boolean          default(FALSE)
#  requested_by                               :integer
#  approved_by                                :integer
#  prenote_status                             :string
#  mail_carrier_id                            :bigint(8)
#  workflow_status_id                         :bigint(8)
#
# Indexes
#
#  index_lease_applications_on_application_identifier  (application_identifier) UNIQUE WHERE (application_identifier IS NOT NULL)
#  index_lease_applications_on_city_id                 (city_id)
#  index_lease_applications_on_colessee_id             (colessee_id)
#  index_lease_applications_on_dealer_id               (dealer_id)
#  index_lease_applications_on_dealership_id           (dealership_id)
#  index_lease_applications_on_department_id           (department_id)
#  index_lease_applications_on_lease_calculator_id     (lease_calculator_id)
#  index_lease_applications_on_lessee_id               (lessee_id)
#  index_lease_applications_on_mail_carrier_id         (mail_carrier_id)
#  index_lease_applications_on_workflow_status_id      (workflow_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (colessee_id => lessees.id)
#  fk_rails_...  (dealer_id => dealers.id)
#  fk_rails_...  (dealership_id => dealerships.id)
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (lease_calculator_id => lease_calculators.id)
#  fk_rails_...  (lessee_id => lessees.id)
#  fk_rails_...  (mail_carrier_id => mail_carriers.id)
#  fk_rails_...  (workflow_status_id => workflow_statuses.id)
#

class LeaseApplication < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :whose_application_identifier_starts_with,
                  against: :application_identifier,
                  using: {
                    tsearch: { prefix: true }
                  },
                  order_within_rank: "lease_applications.updated_at DESC"

  include AASM
  include LeaseApplications::LeasePackageDocumentMethods
  include SimpleAudit::Model
  simple_audit

  enum payment_account_type: { checking: 1, savings: 2 }
  enum colessee_payment_account_type: { checking: 1, savings: 2 }, _prefix: :colessee_payment_account_type
  enum payment_frequency: { full: 0, split: 1, one_time: 2 }, _prefix: :payment_frequency

  with_options dependent: :destroy do |assoc|
    assoc.has_many :references
    assoc.has_many :notifications, as: :notifiable
    assoc.has_many :deleted_colessees,
                   class_name:  'Lessee',
                   foreign_key: 'deleted_from_lease_application_id'
    assoc.has_many :related_applications, foreign_key: 'origin_application_id'
    assoc.has_many :connected_applications, through: :related_applications, source: :related_application
    assoc.has_many :lease_application_attachments
    assoc.has_many :lease_validations
    assoc.has_many :lease_document_requests
    assoc.has_many :lease_application_stipulations
    assoc.has_many :stipulations, -> { order(created_at: :asc) }, through: :lease_application_stipulations
    assoc.has_many :funding_delays

    assoc.has_one :last_lease_document_request, -> { order(created_at: :desc).limit(1).readonly }, class_name: 'LeaseDocumentRequest'
    assoc.has_one :insurance
    assoc.has_one :online_funding_approval_checklist
    assoc.has_one :online_verification_call_checklist

    assoc.belongs_to :lessee
    assoc.belongs_to :colessee, class_name: 'Lessee'
    assoc.belongs_to :lease_calculator
    assoc.has_many :lease_application_blackbox_requests
    assoc.has_many :lease_application_datax_requests
    assoc.has_one :lease_application_credco
    assoc.has_many :lease_application_welcome_calls, ->{ order(updated_at: :desc) }, class_name: "LeaseApplicationWelcomeCall"
    assoc.has_many :prenotes, ->{ order(created_at: :desc) }
    assoc.has_many :negative_pays
    assoc.has_many :funding_request_histories
    assoc.has_one :lease_application_gps_unit
    assoc.has_many :lease_application_recommended_credit_tiers
    assoc.has_many :lease_application_recommended_blackbox_tiers
    assoc.has_many :lease_application_payment_limits
    
    assoc.has_many :comments, -> { order(created_at: :desc) }, as: :resource, class_name: "ActiveAdminComment"
    assoc.has_many :lease_application_underwriting_reviews
    assoc.has_many :decline_reasons
    assoc.has_many :docusign_summaries
  end

  has_many :funding_delay_reasons,
    through: :funding_delays

  belongs_to :dealer
  belongs_to :dealership
  belongs_to :city
  belongs_to :department
  belongs_to :mail_carrier
  belongs_to :workflow_status

  belongs_to :approver,  foreign_key: 'approved_by', class_name: 'AdminUser'
  belongs_to :requester, foreign_key: 'requested_by', class_name: 'AdminUser'

  # TODO: - add a NOT NULL Constraint at the DB level.  Ensure production has no bad data first.
  validates :dealership_id, presence: true
  validates :application_identifier, uniqueness: { allow_blank: true }

  before_validation { |_record| self.dealership_id = dealer.dealership_id if dealer_id.present? && dealership_id.blank? }

  accepts_nested_attributes_for :references, :lease_application_attachments, :funding_delays, :lease_application_stipulations, :lease_application_welcome_calls, :decline_reasons,
    allow_destroy: true

  accepts_nested_attributes_for :lessee, :lease_calculator, :insurance, :online_funding_approval_checklist

  # https://github.com/rails/rails/issues/19490
  # Reject IF's :all_blank does not work with nested attributes
  accepts_nested_attributes_for :colessee,
                                reject_if: proc { |attributes|
                                  attributes.all? do |key, value|
                                    if value.is_a? Hash
                                      value.all? { |nested_key, nested_value| nested_key == '_destroy' || nested_value.blank? }
                                    else
                                      key == '_destroy' || value.blank?
                                    end
                                  end
                                }
  accepts_nested_attributes_for :lessee, 
                                reject_if: proc { |attributes|
                                  attributes.all? do |key, value|
                                    if value.is_a? Hash
                                      value.all? { |nested_key, nested_value| nested_key == '_destroy' || nested_value.blank? }
                                    else
                                      key == '_destroy' || value.blank?
                                    end
                                  end
                                },
                                update_only: true                            

  aasm(:credit_status, whiny_transitions: false) do
    state :unsubmitted, initial: true
    state :draft # temporary to help with old data
    state :awaiting_credit_decision
    state :approved_with_contingencies
    state :approved
    state :requires_additional_information
    state :bike_change_requested
    state :declined
    state :rescinded
    state :withdrawn

    event :submit, after: :set_submitted_at do
      transitions from: %i[draft unsubmitted], to: :awaiting_credit_decision
    end

    event :reset_after_adding_colessee do
      transitions to: :awaiting_credit_decision
    end

    event :rescind do
      transitions to: :rescinded
    end
  end

  aasm(:document_status, whiny_transitions: false) do
    state :no_documents, initial: true
    state :documents_requested
    state :documents_issued
    state :lease_package_received
    state :funding_delay
    state :funding_approved
    state :funded
    state :canceled
  end

  after_update :log_funding_approved, if: :saved_change_to_document_status?
  after_update :log_lease_package_received, if: :saved_change_to_document_status?
  after_update :log_credit_decision_date, if: :saved_change_to_credit_status?
  after_update :send_credit_decision_notification, if: :saved_change_to_credit_status?
  after_update :update_dealership_comission_claback, if: :saved_change_to_document_status?
  after_update :log_funding_delay, if: :saved_change_to_document_status?
  after_update :transfer_status_to_leasepack, if: :saved_change_to_document_status?
  after_update :set_document_issued_date, if: :saved_change_to_document_status?
  after_update :send_welcome_call_request, if: :saved_change_to_document_status?
  after_update :update_shortfund, if: :saved_change_to_this_deal_dealership_clawback_amount?
  after_update :check_funding_request
  after_update :update_tax_jurisdiction
  after_update :notify_for_attachments, if: :saved_change_to_credit_status?
  after_update :send_leases_to_lms, if: :saved_change_to_document_status?
  after_update :remove_decline_reasons, if: :saved_change_to_credit_status?
  

  # TODO Remove this once we migrate off ActiveAdmin
  default_scope -> { includes(:lessee, :lease_calculator).limit(1000) }
  scope :expireable_applications, -> {
    where(arel_table[:submitted_at].lt(30.days.ago)).
      where(expired: false)
  }

  scope :dead_applications, -> do
    where(arel_table[:updated_at].lt(30.days.ago))
      .where.not(lease_calculator: nil)
      .where(lessee: [Lessee.invalid_lessee, nil])
  end

  scope :expired,     -> { where(expired: true) }
  scope :not_expired, -> { where(expired: false) }
  scope :submitted, -> { where.not(credit_status: %w[draft unsubmitted]) }
  scope :submitted_since, ->(timestamp) { submitted.where(arel_table[:submitted_at].gteq(timestamp)) }
  scope :by_dealer_representative, ->(id) { where(application_identifier: [ DealerRepresentative.joins("JOIN dealer_representatives_dealerships AS drd ON dealer_representatives.id = drd.dealer_representative_id JOIN dealerships AS ds ON drd.dealership_id = ds.id JOIN dealers AS d ON ds.id = d.dealership_id JOIN lease_applications AS la ON d.id = la.dealer_id WHERE dealer_representatives.id IN(#{id})").pluck(:application_identifier) ]).where.not(application_identifier: nil) }
  scope :by_calculator_status, ->(status) { joins(:lease_calculator).merge(LeaseCalculator.where(new_used: "#{status}"))}
  scope :by_stipulation, ->(id) { where(id: LeaseApplicationStipulation.where(stipulation_id: id).where.not(status: 'Cleared').pluck(:lease_application_id) ).where.not(application_identifier: nil) }
  scope :by_welcome_call_status, ->(id) { where(id: LeaseApplicationWelcomeCall.find_by_sql("SELECT * FROM (select distinct on (lease_application_id) * from lease_application_welcome_calls order by lease_application_id, created_at desc) as recent where recent.welcome_call_status_id = #{id}").map(&:lease_application_id) ) }
  
  scope :by_lessee_ssn, ->(query = '') {
    result_lessees = Lessee.by_ssn(query)
    where(lessee: result_lessees).or(where(colessee: result_lessees))
  }
  
  scope :by_lessee_ssn_dealership, ->(query = '', dealership_id) {
    result_lessees = Lessee.by_lease_application_dealership(dealership_id).by_ssn(query)

  # scope :by_lessee_ssn_dealership, ->(query = '', dealership_id, name, date_of_birth) {
  #   if !name.nil? && !date_of_birth.nil?
  #     result_lessees = Lessee.by_lease_application_dealership(dealership_id).by_name(name).by_date_of_birth(date_of_birth).by_ssn(query)
  #   end
  #   if !name.nil? && date_of_birth.nil?
  #     result_lessees = Lessee.by_lease_application_dealership(dealership_id).by_name(name).by_ssn(query)
  #   end
  #   if name.nil? && !date_of_birth.nil?
  #     result_lessees = Lessee.by_lease_application_dealership(dealership_id).by_date_of_birth(date_of_birth).by_ssn(query)
  #   end

  #   if name.nil? && date_of_birth.nil?
  #     result_lessees = Lessee.by_lease_application_dealership(dealership_id).by_ssn(query)
  #   end
    where(lessee: result_lessees).or(where(colessee: result_lessees))
  }

  scope :by_lessee_name, -> (name) {
    result_lessees = Lessee.by_name(name.upcase)
    where(lessee: result_lessees).or(where(colessee: result_lessees))
  }
  
  scope :by_lessee_full_name, -> (name) {
    names = name.upcase.split(" ")
    result_lessees = Lessee.by_full_name(names)
    where(lessee: result_lessees)
  }

  scope :by_lessee_first_name, -> (name) {
    result_lessees = Lessee.by_first_name(name.upcase)
    where(lessee: result_lessees)
  }

  scope :by_lessee_last_name, -> (name) {
    result_lessees = Lessee.by_last_name(name.upcase)
    where(lessee: result_lessees)
  }

  scope :by_colessee_full_name, -> (name) {
    names = name.upcase.split(" ")
    result_colessees = Lessee.by_full_name(names)
    where(colessee: result_colessees)
  }

  scope :by_colessee_first_name, -> (name) {
    result_colessees = Lessee.by_first_name(name.upcase)
    where(colessee: result_colessees)
  }

  scope :by_colessee_last_name, -> (name) {
    result_colessees = Lessee.by_last_name(name.upcase)
    where(colessee: result_colessees)
  }

  scope :has_application_eq, ->(boolean = true) {
    case boolean
      when true, 'true'
        joins(:lessee).merge(Lessee.valid_lessee)
      when false, 'false'
        joins(:lessee).merge(Lessee.invalid_lessee)
      when nil, ''
        all # scoped, no-op
    end
  }

  scope :has_calculator_eq, ->(boolean = true) {
    case boolean
      when true, 'true'
        joins(:lease_calculator).merge(LeaseCalculator.with_monthly_payments_greater_than_zero)
      when false, 'false'
        joins(:lease_calculator).merge(LeaseCalculator.without_monthly_payments_greater_than_zero)
      when nil, ''
        all # scoped no-op
    end
  }

  scope :has_coapplicant_eq, ->(boolean = true) {
    case boolean
      when true, 'true'
        where.not(colessee: nil).joins(:colessee).merge(Lessee.valid_lessee)
      when false, 'false'
        where(colessee_id: nil)
    end
  }

  scope :can_change_bikes_eq, ->(boolean = true) {
    case boolean
      when true, 'true'
        where(document_status: :no_documents, credit_status: [:approved, :approved_with_contingencies], expired: false)
      when false, 'false'
        #DeMorgan's Law opposite of the above.  You can't just do `where.not()` on the above :(
        #https://stackoverflow.com/questions/47777425/rails-not-query-on-entire-where-clause
        where.not(document_status: :no_documents).
          or(where.not(credit_status: [:approved, :approved_with_contingencies])).
          or(where.not(expired: false))
    end
  }

  scope :with_year, lambda { |year| where('extract(year from created_at) = ?', year) }
  scope :with_range, lambda { |start_range, end_range| where(created_at: Date.parse("#{start_range}")..Date.parse("#{end_range}"))}

  def self.ransackable_scopes(_auth_object = nil)
    %i[has_application_eq has_calculator_eq has_coapplicant_eq can_change_bikes_eq by_lessee_ssn by_dealer_representative by_calculator_status by_stipulation by_welcome_call_status by_lessee_name by_lessee_full_name by_lessee_first_name by_lessee_last_name by_colessee_full_name by_colessee_first_name by_colessee_last_name]
  end

  delegate :asset_year, :asset_model, :tax_jurisdiction,
           to:        :lease_calculator,
           allow_nil: true

  delegate :first_name, :last_name,
           to:        :lessee,
           prefix:    true,
           allow_nil: true

  delegate :state, :name,
           to:        :dealership,
           prefix:    true,
           allow_nil: true

  def retrieve_audits
    # TODO
    # audits for this Lease Application
    # audits for Lessee
    # audits for Address
    # audits for LeaseCalculator
    audits_with_parents = Audit.with_parents(id)
    audits_with_dealers = audits.with_dealers.includes(:audited, user: :dealership).limit(1000) + audits_with_parents.with_dealers.includes(:audited, user: :dealership).limit(1000)
    audits_with_admin_users = audits.with_admin_users.includes(:audited, :user).limit(1000) + audits_with_parents.with_admin_users.includes(:audited, :user).limit(1000)
    audits_with_no_users = audits.with_no_users.includes(:audited).limit(1000) + audits_with_parents.with_no_users.includes(:audited).limit(1000)
    (audits_with_dealers + audits_with_admin_users + audits_with_no_users).sort { |a, b| b.created_at <=> a.created_at }
  end

  def display_name
    return application_identifier if application_identifier
    "#{lessee_last_name}, #{lessee_first_name} (#{asset_year || '20??'} #{asset_model || 'Bike'})"
  end

  def submitted?
    submitted_at.present?
  end

  def set_submitted_at
    touch(:submitted_at)
  end

  # If the lease calculator doesnt exist, initialize a blank calculator
  # Used in ActiveAdmin so we can click a button an "edit" a Lease Calculator
  # without having to create blank calculators through callbacks or other means.
  def load_or_create_lease_calculator
    # TODO: does inverse_of option simplify this???
    calc = lease_calculator || create_lease_calculator!
    save # saves the foreign key if needed
    calc
  end

  def self.find_by_url(url)
    return unless url.respond_to?(:match)
    if (path = url.match(/lease_applications\/\d+/)) || (path = url.match(/lease_calculators\/\d+/))
      record_type  = path.to_s.split('/')[0]
      record_id    = path.to_s.split('/')[1]
      found_record = record_type.camelcase.chop.constantize.find(record_id)
      return found_record if found_record.is_a? LeaseApplication
      return found_record.lease_application if found_record.is_a? LeaseCalculator
    end
  end

  def send_credit_decision_notification
    statuses_requiring_notification = %w(approved approved_with_contingencies requires_additional_information declined rescinded withdrawn)
    return unless statuses_requiring_notification.include? credit_status

    Notification.create_for_dealership({
                                         notification_mode:    'Email',
                                         notification_content: 'credit_decision',
                                         notifiable:           self
                                       }, dealership: dealership)
  end

  def upfront_sales_tax_state
    obj_state = UsState.find_by_abbreviation(lessee&.home_address&.state)
    return nil unless obj_state.present?
    result = if(obj_state.tax_jurisdiction_type&.name&.start_with?("Customer"))
        lessee&.home_address&.state
    elsif (obj_state.tax_jurisdiction_type&.name&.start_with?("Dealer"))
          if(obj_state.abbreviation == dealer&.dealership&.address&.state)
              dealer&.dealership&.address&.state
          else
              lessee&.home_address&.state
          end   
    else 
      nil
    end
    return result
  end

  def upfront_taxes_and_location_geocodes
    us_state = UsState.find_by_abbreviation(lessee&.home_address&.state)
    return nil unless us_state.present?
    city_obj = self.city
    if (us_state.tax_jurisdiction_type&.name&.start_with?("Dealer") && (us_state.abbreviation == dealer&.dealership&.address&.state))
      us_state = UsState.find_by_abbreviation(dealer&.dealership&.address&.state)
      city_name = dealer&.dealership&.address&.city
      zipcode = dealer&.dealership&.address&.zipcode
      county_name = dealer&.dealership&.address&.county
      county_obj = County.where(us_state_id: us_state&.id, name: county_name).first
      city_obj = City.where(county_id: county_obj&.id, name: city_name, us_state_id: us_state&.id).where("'#{zipcode}' between city_zip_begin and city_zip_end").first
    end
    tax_juridiction = TaxJurisdiction.where(us_state: us_state.id, name: tax_jurisdiction).first
    {state: tax_juridiction&.state_upfront_tax_percentage, county: tax_juridiction&.county_upfront_tax_percentage, city: tax_juridiction&.local_upfront_tax_percentage, state_geocode: city_obj&.geo_state, county_geocode: city_obj&.geo_county, city_geocode: city_obj&.geo_city}
  end

  def log_lease_package_received
    return unless document_status == 'lease_package_received'
    update_column(:lease_package_received_date, Time.now)
    dealers = dealership.active_dealers.select{ |d| d.notify_funding_decision }

    dealers.each do |dealer|       
      DealerMailer.dealer_notification(application: self, dealer: dealer, status: 'lease_package_received').deliver_now
    end

    if EmailTemplate.lease_package_recieved.enable_template && ENV['MAILER_OUTGOING_LESSEE'].eql?('enabled')
      LesseeMailer.funding_package_received(recipient: self&.lessee&.email_address, app: self).deliver_now if self&.lessee&.email_address.present?
      LesseeMailer.funding_package_received(recipient: self&.colessee&.email_address, app: self).deliver_now if self&.colessee&.email_address.present?
    end
    
  end

  def log_funding_approved
    return unless document_status == 'funding_approved'
    update_column(:funding_approved_on, Time.now)
    dealers = dealership.active_dealers.select{ |d| d.notify_funding_decision }
    
    dealers.each do |dealer|       
      #DealerMailer.dealer_notification(application: self, dealer: dealer, status: 'funding_approved').deliver_now
      Notification.create({
                             notification_mode:    'Email',
                             notification_content: 'funding_approved',
                             notifiable:           self,
                             recipient: dealer
                           })
      end
  end

  def log_credit_decision_date
    update_column(:credit_decision_date, Time.now)
  end

  def log_funding_delay
    return unless document_status == 'funding_delay'
    update_column(:funding_delay_on, Time.now)
    dealers = dealership.active_dealers.select{ |d| d.notify_funding_decision }

    dealers.each do |dealer|          
      # DealerMailer.dealer_notification(application: self, dealer: dealer, status: 'funding_delay').deliver_now 
      Notification.create({
                           notification_mode:    'Email',
                           notification_content: 'funding_delay',
                           notifiable:           self,
                           recipient: dealer
                         })
    end
    
  end

  def update_dealership_comission_claback    
    return unless document_status == 'funded'    
    dealers = dealership.active_dealers.select{ |d| d.notify_funding_decision }

    dealers.each do |dealer|            
      #DealerMailer.dealer_notification(application: self, dealer: dealer, status: 'funded').deliver_now      
      Notification.create({
                           notification_mode:    'Email',
                           notification_content: 'funded',
                           notifiable:           self,
                           recipient: dealer
                         })
    end

    # if dealership.commission_clawback_amount.present?
    #  this_deal_dealership_clawback_amount_var = this_deal_dealership_clawback_amount.blank? ? 0 : this_deal_dealership_clawback_amount
    #  dealership.update_column(:commission_clawback_amount, dealership.commission_clawback_amount - this_deal_dealership_clawback_amount_var)
    # end
  end

  def transfer_status_to_leasepack
    if (document_status == 'funding_approved') || (document_status == 'funded' && funded_on.present?)
      TransferStatusToLeasepakJob.perform_in(15.seconds, self.id)
    end
  end

  def set_document_issued_date
    if (document_status == 'documents_issued') && !documents_issued_date_changed?
      update_column(:documents_issued_date, Time.zone.now.to_date)
    end
  end
  
  def send_welcome_call_request
    return unless document_status == 'funded'
    self.dealership.dealer_representatives.each do |representative|
      adminuser = AdminUser.find_by(email: representative.email)
      self.update_column(:welcome_call_due_date, calculate_welcome_call_due_date) 
      this_lease_applicaton = LeaseApplication.find(self.id) #refetch to get update
      self.lease_application_welcome_calls.create(welcome_call_status_id: 3, admin_id: adminuser&.id, welcome_call_representative_type_id: 2, due_date: this_lease_applicaton.welcome_call_due_date)
      DealerRepresentativeMailer.welcome_call_request(recipient: representative, application: this_lease_applicaton).deliver_later(wait_until: 14.days.from_now)
    end
  end
  
  def calculate_welcome_call_due_date
    return nil if self.funding_approved_on.nil? || self.first_payment_date.nil?
    funding_approved_calc = self.funding_approved_on + 1.days
    first_payment_date_calc = self.first_payment_date - 15.days
    due_date = ( funding_approved_calc > first_payment_date_calc) ? funding_approved_calc : first_payment_date_calc
  end

  def self.credit_tier_range(lcs)
    lcs = lcs.presence || 0
    if lcs >= 700
      1
    elsif lcs <= 699 && lcs >= 670
      2
    elsif lcs <= 669 && lcs >= 640
      3
    elsif lcs <= 639 && lcs >= 610
      4
    elsif lcs <= 609 && lcs >= 580
      5
    elsif lcs <= 579 && lcs >= 550
      6
    elsif lcs <= 549 && lcs >= 520
      7
    elsif lcs <= 519 && lcs >= 490
      8
    elsif lcs <= 489 && lcs >= 460
      9
    elsif lcs <= 459 && lcs >= 0
      10
    end
  end

  def employment_status
      self&.lessee&.employment_status_definition&.definition
  end

  # @return [Array<LeaseApplicationBlackboxRequest>]
  def datax_employment_details
    begin
      self.lease_application_blackbox_requests.select do |datax|
        return false unless datax.leadrouter_response.present?

        if datax.leadrouter_response.respond_to?(:dig)
          # Skip parsing if its already serialized as JSON
          datax.leadrouter_response.dig("extraAttributes", "twn_raw_report", "DataxResponse", "TWNSelectSegment", "EmployerName").present?
        else
          parsed = JSON.parse(datax.leadrouter_response)
          parsed.dig("extraAttributes", "twn_raw_report", "DataxResponse", "TWNSelectSegment", "EmployerName").present? if parsed.respond_to?(:dig)
        end
      end
    rescue StandardError => e
      Rails.logger.info "Getting an error while parsing datax response for LeaseApplication ID = #{self.id} & message = #{e.message}"
    end
  end

  def get_prenote_status
    return 'not_started' unless prenote_status
    prenote_status
  end

  def payment_info_exists
    [
    self&.payment_aba_routing_number.nil?,
    self&.payment_account_number.nil?,
    self&.payment_account_type.nil?,
    self&.payment_account_holder.nil?,
    self&.first_payment_date.nil?,
    self&.payment_first_day.nil?,
    self&.second_payment_date.nil?,
    self&.payment_second_day.nil?,
    ].include?(false)
  end


  def ordinalize_payment_dates
    return "#{self&.first_payment_date&.day&.ordinalize} and #{self&.second_payment_date&.day&.ordinalize}" if self&.payment_frequency == "split"
    self&.first_payment_date&.day&.ordinalize
  end

  def payment_amount
    return (self&.lease_calculator&.total_monthly_payment * 0.5).round(2)&.to_money&.to_s if self&.payment_frequency == "split"
    self&.lease_calculator&.total_monthly_payment&.to_money&.to_s
  end

  def check_funding_request(override: false)
    return unless document_status == 'funding_approved'
    if funding_request_histories.empty?
      send_funding_request(false)
    else
      last_funding_request = funding_request_histories.order(:created_at)&.last
      is_still_same_amount = lease_calculator&.remit_to_dealer_less_shortfund == last_funding_request&.amount

      if override || !is_still_same_amount
        send_funding_request(true)
      end
    end
  end

  def update_shortfund
    is_initial_value_zero = (lease_calculator&.dealer_shortfund_amount + this_deal_dealership_clawback_amount.to_money) == 0
    is_remit_to_dealer_less_shortfund_zero = lease_calculator.remit_to_dealer_less_shortfund == 0
    is_not_same_value = this_deal_dealership_clawback_amount.to_money !=  lease_calculator&.dealer_shortfund_amount
    if is_not_same_value || is_initial_value_zero || is_remit_to_dealer_less_shortfund_zero
      lease_calculator.dealer_shortfund_amount = this_deal_dealership_clawback_amount
      lease_calculator.remit_to_dealer_less_shortfund = (lease_calculator.remit_to_dealer - this_deal_dealership_clawback_amount.to_money)
      lease_calculator.save!
    end
  end


  def send_funding_request(is_revised)
    #create history first to avoid duplicate
    funding_request_histories.create(amount: lease_calculator&.remit_to_dealer_less_shortfund)
    FundingRequestFormJob.perform_at(15.seconds.from_now,id, is_revised)
  end


  def update_tax_jurisdiction
    # return if lease_calculator.nil? || lessee&.home_address.nil? || lessee&.home_address&.state == 'GA'
    # lease_application_states = UsState::LEASE_APPLICATION_STATES.keys
    # if !lessee&.home_address.nil? && !lease_calculator.nil? && (lease_application_states.include? lessee&.home_address&.state)
    return if lease_calculator.nil? || lessee&.home_address.nil?
    if !lessee&.home_address.nil? && lease_calculator&.us_state.nil? && !lease_calculator.nil?
      all_other_counties = 'All Other Counties'
      state_res = UsState.find_by_abbreviation(lessee&.home_address&.state)
      lease_calculator.us_state = state_res&.name

      if state_res&.tax_jurisdiction_type&.name&.include?("County")
        tax_jurisdiction_res = TaxJurisdiction.where(us_state: state_res.name).where("name LIKE ?", "%#{lessee&.home_address&.county&.humanize}%").first
        if tax_jurisdiction_res.nil?
          tax_jurisdiction_names = TaxJurisdiction.where(us_state: state_res.name).order(:name).pluck(:name)
          lease_calculator.tax_jurisdiction = tax_jurisdiction_names.first
          lease_calculator.tax_jurisdiction = all_other_counties if tax_jurisdiction_names.include?(all_other_counties)
        else
          lease_calculator.tax_jurisdiction = tax_jurisdiction_res.name
        end
      end
      if state_res&.tax_jurisdiction_type&.name&.include?("ZIP")
        tax_jurisdiction_res = TaxJurisdiction.where(us_state: state_res.name).where("name LIKE ?", "%#{lessee.home_address.zipcode.first(5)}%").first
        if tax_jurisdiction_res.nil?
          lease_calculator.tax_jurisdiction = TaxJurisdiction.where(us_state: state_res.name).order(:name).pluck(:name).first
        else 
          lease_calculator.tax_jurisdiction = tax_jurisdiction_res.name
        end
      end
      lease_calculator.save!
    end
  end

  def notify_underwriting 
    DealershipMailer.notify_underwriting(recipient: underwriting_approvers, app: self).deliver_now
  end

  def underwriting_approvers
    WorkflowSettingValue.where(workflow_setting_id: WorkflowSetting.underwriting.id).map{ |setting| setting.admin_user.email }
  end

  def notify_for_attachments
    statuses_requiring_notification = %w(approved approved_with_contingencies)
    return unless statuses_requiring_notification.include? credit_status
    AttachmentNotificationMailer.notify(app: self).deliver_now if (ENV['NOTIFY_LESSEE_ATTACHMENT'] || ENV['NOTIFY_DEALERSHIP_ATTACHMENT'])
  end

  def is_disable_credit_status_approved
    has_blocking_stipulation = lease_application_stipulations.where(stipulation_id: Stipulation.blocks_credit_status_approved.pluck(:id)).where(status: 'Required')
    return true unless has_blocking_stipulation&.empty?
    return true if lessee&.income_verifications&.empty?
    return true if colessee.nil? && !colessee&.income_verifications&.empty? && is_lessee_colessee_address_same
    # return true if ['Application', 'Underwriting Review'].include?(workflow_status&.description)
    return false
  end


  def is_lessee_colessee_address_same
    return false if lessee.nil? || colessee.nil?
    (lessee&.home_address&.city_id == colessee&.home_address&.city_id)
  end

  def send_leases_to_lms
    lms = LeaseManagementSystem.first
    return unless (lms.document_status == document_status  && lms&.send_leases_to_lms)
    begin
      log_group_type
      adjusted_capitalized_cost_log
      invoice_code_log
      ssn_log
      payload = ActiveModelSerializers::SerializableResource.new(self, serializer: LeaseApplicationLmsSerializer, adapter: :json, key_transform: :camel_lower, root: false )
      response = JSON.parse(RestClient::Request.execute(
        method: :post, 
        url: lms&.api_destination , 
        payload:  JSON.parse(payload.to_json).merge!({email: ENV['BRIDGING_EMAIL'], password: ENV['BRIDGING_PASSWORD']})
        )) 
      Rails.logger.info(response)
    rescue => e
      Rails.logger.info(e)
      Rails.logger.info(e.backtrace)
    end
  end

  def vendor_number
    vendor_name = self&.dealership&.name
    vendor_num = ""
    case vendor_name
    when "American Motorcycle Trading Co"
      vendor_num = "10001"
    when "BuyYourMotorcycle.com"
      vendor_num = "10002"
    when "CAPITAL CITY CYCLES"
      vendor_num = "10003"
    when "DREAM MACHINES OF TEXAS"
      vendor_num = "10004"
    when "Harley-Davidson of Waco"
      vendor_num = "10005"
    when "SOUTHERN TRUCK AND EQUIPMENT I"
      vendor_num = "10006"
    when "Kevin Powell's Performance Mot"
      vendor_num = "10007"
    when "Kevin Powell's Triad Powerspor"
      vendor_num = "10008"
    when "Kevin Powell's Forsyth Motorsp"
      vendor_num = "10009"
    when "LUCKY U CYCLES LLC"
      vendor_num = "10010"
    when "Motor Export Experts"
      vendor_num = "10011"
    when "Stormy Hill Harley-Davidson"
      vendor_num = "10012"
    when "Boneyard Cycles LLC"
      vendor_num = "10013"
    when "Carolina V-Twin"
      vendor_num = "10014"
    when "Dream Machines Indian Motorcyc"
      vendor_num = "10015"
    when "Elite Motor Sports"
      vendor_num = "10016"
    when "Faith Cycles LLC"
      vendor_num = "10017"
    when "Hopper Motorplex, Inc"
      vendor_num = "10018"
    when "Legend Cycles"
      vendor_num = "10019"
    when "Main Street Powersports, LLC"
      vendor_num = "10020"
    when "Tesch Auto & Cycle"
      vendor_num = "10021"
    when "Darin Grooms Auto Sports Inc"
      vendor_num = "10022"
    when "Indian Motorcycle of Fort Laud"
      vendor_num = "10023"
    when "MJB Sales LTD"
      vendor_num = "10024"
    when "LAKELAND HARLEY-DAVIDSON"
      vendor_num = "10025"
    when "FLIP MY CYCLE"
      vendor_num = "10030"
    when "Cycle Exchange LLC"
      vendor_num = "10034"
    when "17 Customs"
      vendor_num = "10036"
    when "MC Cycles LLC"
      vendor_num = "10037"
    when "Southwest Cycle"
      vendor_num = "10039"
    when "Wild Child Cycles"
      vendor_num = "10040"
    when "Velocity Motorworx"
      vendor_num = "10042"
    when "Family Powersports"
      vendor_num = "10043"
    when "TRG Motor Company"
      vendor_num = "10044"
    when "AZ Auto RV, LLC"
      vendor_num = "10046"
    when "The Car Connection LLC"
      vendor_num = "10047"
    when "Gator Harley-Davidson"
      vendor_num = "10050"
    when "Classic Iron"
      vendor_num = "10051"
    when "BURKES REPO OUTLET"
      vendor_num = "10053"
    when "North Ridge Custom Cycles"
      vendor_num = "10056"
    when "SpinWurkz"
      vendor_num = "10058"
    when "469 Cycle Shop"
      vendor_num = "10059"
    when "Midwest Motorcycle of Daytona"
      vendor_num = "10062"
    when "C&C Thunder"
      vendor_num = "10066"
    when "Indian Motorcycle of Savannah"
      vendor_num = "10067"
    when "Ronnie's V-Twin Cycles"
      vendor_num = "10070"
    when "1 Stop Harleys"
      vendor_num = "10071"
    when "St. Pete Powersports"
      vendor_num = "10078"
    when "Cycle Nation of McDonough"
      vendor_num = "10090"
    when "Freedom Powersports Hurst"
      vendor_num = "10093"
    when "Big Tex Indian Motorcycle"
      vendor_num = "10096"
    when "Atlanta Highway Indian Motorcy"
      vendor_num = "10097"
    when "Rock City Cycles"
      vendor_num = "10101"
    when "All Out Powersports"
      vendor_num = "10102"
    when "Smoky Mountain Harley-Davidson"
      vendor_num = "10105"
    when "Paris Harley-Davidson"
      vendor_num = "10109"
    when "Jim's Motorcycle Service"
      vendor_num = "10110"
    when "Motorcycle Wholesale Outlet"
      vendor_num = "10111"
    when "Independent Motorsports"
      vendor_num = "10112"
    when "Action Powersports"
      vendor_num = "10113"
    when "EuroTek OKC"
      vendor_num = "10116"
    when "Buckeye City Motorsports"
      vendor_num = "10117"
    when "Sooner Indian Motorcycle"
      vendor_num = "10118"
    when "Mobile Bay Harley-Davidson"
      vendor_num = "10126"
    when "Chunky River Harley-Davidson"
      vendor_num = "10131"
    when "Chicago Cycles & Motorsports"
      vendor_num = "10132"
    when "Music City Indian Motorcycle"
      vendor_num = "10133"
    when "America's Motorsports Madison"
      vendor_num = "10134"
    when "Lumberjack Harley-Davidson"
      vendor_num = "101135"
    when "Top Spoke LLC"
      vendor_num = "101136"
    when "Lucky Penny Cycles"
      vendor_num = "10140"
    when "Texarkana Harley-Davidson"
      vendor_num = "10146"
    when "Texas Harley-Davidson"
      vendor_num = "10147"
    when "Dead End Cycles"
      vendor_num = "10153"
    when "COZIAHR HARLEY-DAVIDSON"
      vendor_num = "10154"
    when "EVOLUTION POWERSPORTS"
      vendor_num = "10156"
    when "HIGH PLAINS HARLEY-DAVIDSON"
      vendor_num = "10157"
    when "LIMA HARLEY-DAVIDSON"
      vendor_num = "10159"
    when "MR. MOTORHEAD"
      vendor_num = "10160"
    when "PRIMO MOTORCYCLES"
      vendor_num = "10161"
    when "FORT THUNDER HARLEY-DAVIDSON"
      vendor_num = "10167"
    when "BUSTED NUCKLE"
      vendor_num = "10168"
    when "SOUTH MAIN IRON"
      vendor_num = "10171"
    when "MISSION CITY INDIAN MOTORCYCLE"
      vendor_num = "10173"
    when "PINUP BAGGERS"
      vendor_num = "10175"
    when "American Classic Motors"
      vendor_num = "10181"
    when "CENTRAL TEXAS HARLEY-DAVIDSON"
      vendor_num = "10184"
    when "CHAMPION MOTORSPORTS"
      vendor_num = "10189"
    when "HARLEY-DAVIDSON OF DALLAS"
      vendor_num = "10191"
    when "INCREDIBLE CAR CREDIT"
      vendor_num = "10194"
    when "OSBORN USA"
      vendor_num = "10196"
    when "JOKER POWERSPORTS LLC"
      vendor_num = "10198"
    when "IMOTORSPORTS ORLANDO"
      vendor_num = "10201"
    when "FREEDOM CYCLES"
      vendor_num = "10204"
    when "Big #1 Motorsports"
      vendor_num = "10206"
    when "Next Ride Largo"
      vendor_num = "10209"
    when "Next Ride Tampa"
      vendor_num = "10210"
    when "Destination Powersports"
      vendor_num = "10214"
    when "Tifton Harley-Davidson"
      vendor_num = "10219"
    when "Wilmington Powersports"
      vendor_num = "10222"
    when "Sky Powersports North Orlando"
      vendor_num = "10223"
    when "DESTINATION HONDA"
      vendor_num = "10232"
    when "SUPERSTITION HARLEY-DAVIDSON"
      vendor_num = "10233"
    when "PRIME MOTORCYCLES"
      vendor_num = "10236"
    when "Desert Thunder Motorsports"
      vendor_num = "10239"
    when "PLANET POWERSPORTS"
      vendor_num = "10245"
    when "PLANET POWERSPORTS"
      vendor_num = "10245"
    when "Myers-Duren Harley-Davidson"
      vendor_num = "10247"
    when "COWBOY HARLEY-DAVIDSON OF AUST"
      vendor_num = "10253"
    when "BBV POWERSPORTS"
      vendor_num = "10263"
    when "BLUE RIDGE HARLEY-DAVIDSON"
      vendor_num = "10267"
    when "METROLINA MOTORSPORTS OF KM, I"
      vendor_num = "10269"
    when "Indian Motorcycle of Oklahoma"
      vendor_num = "10273"
    when "LEGENDS CYCLE OF MISSOURI"
      vendor_num = "10274"
    when "Longshore Cycle Center"
      vendor_num = "10275"
    when "THE CHOPPER GALLERY, INC."
      vendor_num = "10278"
    when "Sir Pete's Back Alley Motorcyc"
      vendor_num = "10281"
    when "Dream Machines of San Antonio"
      vendor_num = "10283"
    when "French Valley Flying Circus"
      vendor_num = "10284"
    when "Bumpus Harley-Davidson of Memp"
      vendor_num = "10285"
    when "Major Powersports"
      vendor_num = "10287"
    when "Harley-Davidson of Yuba City"
      vendor_num = "10293"
    when "AMERICAN V TWIN, INC."
      vendor_num = "10295"
    when "Worth Harley-Davidson"
      vendor_num = "10296"
    when "COWBOY'S ALAMO CITY HARLEY-DAV"
      vendor_num = "10297"
    when "SUN SPORTS CYCLE AND WATERCRAF"
      vendor_num = "10298"
    when "Iron Power Sports"
      vendor_num = "10300"
    when "HD American Cycles"
      vendor_num = "10301"
    when "THUNDER TOWER WEST HARLEY-DAVI"
      vendor_num = "10321"
    when "FULL THROTTLE MOTORSPORTS"
      vendor_num = "10324"
    when "COWBOY HARLEY-DAVIDSON OF BEAU"
      vendor_num = "10327"
    when "East Carolina Powersports"
      vendor_num = "10328"
    when "East Carolina Powersports"
      vendor_num = "10328"
    when "Boca Powersports"
      vendor_num = "10333"
    when "Cycle World"
      vendor_num = "10337"
    when "LONGHORN HARLEY-DAVIDSON"
      vendor_num = "10339"
    when "Sky Powersports Sanford"
      vendor_num = "10344"
    when "Iron Steed Harley-Davidson"
      vendor_num = "10346"
    when "CERTIFIED MOTOR COMPANY"
      vendor_num = "10348"
    when "BW Motorsports"
      vendor_num = "10350"
    when "Hammond Harley-Davidson"
      vendor_num = "10352"
    when "Fortunauto 13"
      vendor_num = "10354"
    when "Bootlegger Harley-Davidson"
      vendor_num = "10360"
    when "Oakland Harley-Davidson"
      vendor_num = "10371"
    when "PIT STOP CYCLE SHOP"
      vendor_num = "10376"
    when "All American Harley-Davidson"
      vendor_num = "10379"
    when "G & S Suzuki"
      vendor_num = "10383"
    when "Capital Honda Powersports"
      vendor_num = "10385"
    when "RUHNKE'S XTREME CYCLES LLC"
      vendor_num = "10387"
    when "A & T CYCLES"
      vendor_num = "10393"
    when "Republic Harley-Davidson"
      vendor_num = "10401"
    when "M & K AUTO SALES"
      vendor_num = "10402"
    when "NATCHEZ TRACE HARLEY-DAVIDSON"
      vendor_num = "10404"
    when "Harley-Davidson of Macon"
      vendor_num = "10409"
    when "Otwell Enterprises"
      vendor_num = "10410"
    when "New Orleans Harley-Davidson"
      vendor_num = "10411"
    when "Warhawk Harley-Davidson"
      vendor_num = "10413"
    when "CAJUN HARLEY-DAVIDSON"
      vendor_num = "10414"
    when "HERB EASLEY MOTORS"
      vendor_num = "10417"
    when "MOONSHINE HARLEY-DAVIDSON"
      vendor_num = "10423"
    when "California Harley-Davidson"
      vendor_num = "10424"
    when "Victoria Harley-Davidson"
      vendor_num = "10433"
    when "Busch's Chop Shop"
      vendor_num = "10437"
    when "Motorsports4u.com"
      vendor_num = "10440"
    when "TIMMS HARLEY DAVIDSON"
      vendor_num = "10441"
    when "Boondox Motorsports"
      vendor_num = "10457"
    when "Lucky Penny Cycles Houston"
      vendor_num = "10460"
    when "Midnight Motors"
      vendor_num = "10471"
    when "TX Toy Sales"
      vendor_num = "10472"
    when "Motor City Harley-Davidson"
      vendor_num = "10473"
    when "Caliente Harley Davidson"
      vendor_num = "10491"
    when "Wicked Wrench Motorcycle"
      vendor_num = "10492"
    end
    vendor_num
    Rails.logger.info("#################################### VENDOR NUM: #{vendor_num} ####################################")
  end

  # check adjusted_capitalized_cost_log
  def adjusted_capitalized_cost_log
    adjusted_capitalized_cost = self&.lease_calculator&.adjusted_capitalized_cost ? self&.lease_calculator&.adjusted_capitalized_cost : "N/A"
    Rails.logger.info("#################################### ADJUSTED CAPITALIZED COST: #{adjusted_capitalized_cost} ####################################")
  end

  def invoice_code_log
    state = self&.dealership&.state
    Rails.logger.info("#################################### the state is: #{state} ####################################")
  end

  def ssn_log
    ssn = self&.lessee&.ssn ? self&.lessee&.ssn : "N/A"
    Rails.logger.info("#################################### SSN: #{ssn} ####################################")
  end

   # This function log the type of group from "ModelGroup"
  def log_group_type
    group_name = self&.lease_calculator&.model_year&.model_group&.name
    type = ""
    case group_name
    when "Chief"
      type = "MC001"
    when "Dyna"
      type = "MC002"
    when "Scout"
      type = "MC003"
    when "Sportster"
      type = "MC005"
    when "Street"
      type = "MC006"
    when "Touring"
      type = "MC007"
    when "VRSC"
      type = "MC008"
    when nil
      type = "other category"
    end

    Rails.logger.info("#################################### the model group type is: #{type} ####################################")
  end 

  def welcome_call_due_date_utc
    if self&.welcome_call_due_date?
      self&.welcome_call_due_date.utc.iso8601
    end
  end

  def remove_decline_reasons
    if credit_status != "declined"
      self&.decline_reasons&.destroy_all
    end
  end

  def expiration_date
    if expired
      'Expired'
    elsif submitted?
      submitted_at + 60.days
    else
      ''
    end
  end
  
end
