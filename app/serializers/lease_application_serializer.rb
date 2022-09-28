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

class LeaseApplicationSerializer < ApplicationSerializer
  attributes :id, :application_identifier, :document_status, :credit_status, :documents_issued_date, 
             :is_verification_call_completed,:funding_delay_on, :funding_approved_on,
             :funded_on, :lease_package_received_date, :dealership, :payment, :calculator,
             :vehicle, :lease_application_welcome_call_form, :document_status_options,
             :payment_account_holder_options, :colessee_account_joint_to_lessee_options, :payment_account_type_options, :payment_frequency_options,
             :prenote_status, :mail_carrier_options, :mail_carrier_id, :approved_by, :funding_approval_complete, 
             :payment_info_exists, :lease_validations, :datax_employment_details, :stipulation_lease_application_attachments,
             :credit_status_options, :workflow_status_options, :workflow_status_id, :workflow_status_description, :payment_frequency,
             :credit_reports, :lessee_credit_summary, :colessee_credit_summary, :credit_average_summary, :deleted_colessees,
             :lease_application_attachments, :audits, :attachment_category_options,
             :income_frequency_options, :income_verification_type_options, :income_verification_record_options, :vehicle_possession,
             :lease_verification_call, :welcome_call_due_date_utc, :the_approver, :the_reviewer,:documents_requested_date,
             :decline_reason_type_options, :decline_reasons, :expired, :notifications, :action_permission, :credit_status_value,
             :dealer, :docusign_histories

  belongs_to :lessee,                             serializer: LesseeSerializer
  belongs_to :insurance,                          serializer: InsuranceSerializer
  belongs_to :colessee, class_name: 'Lessee',     serializer: LesseeSerializer
  belongs_to :online_funding_approval_checklist,  serializer: OnlineFundingApprovalChecklistSerializer

  has_many :funding_delays,                       serializer: FundingDelaysSerializer
  has_many :lease_application_welcome_calls,      serializer: LeaseApplicationWelcomeCallsSerializer
  has_many :references,                           serializer: ReferenceSerializer
  has_many :negative_pays,                        serializer: NegativePaySerializer
  has_many :prenotes,                             serializer: PrenoteSerializer
  has_many :lease_application_stipulations,       serializer: LeaseApplicationStipulationSerializer
  has_many :lease_document_requests,              serializer: LeaseDocumentRequestSerializer
  has_many :lease_application_blackbox_requests,  serializer: LeaseApplicationBlackboxRequestSerializer
  has_many :comments,                             serializer: ActiveAdminCommentSerializer
  has_many :connected_applications,               serializer: RelatedApplicationSerializer, key: :historical_related
  has_many :decline_reasons,                      serializer: DeclineReasonSerializer

  has_one :lease_application_gps_unit,            serializer: LeaseApplicationGpsUnitSerializer

  def datax_employment_details
    details = ActiveModelSerializers::SerializableResource.new(object&.datax_employment_details || nil)
  end

  def lease_validations
    ActiveModelSerializers::SerializableResource.new(object&.lease_validations.includes(:validatable).limit(1000)) || []
  end

  def lease_application_attachments
    ActiveModelSerializers::SerializableResource.new(object&.lease_application_attachments.includes(:uploader).limit(1000).order(created_at: :desc)) || []
  end

  def approved_by
    object&.approver&.full_name
  end

  def funding_approval_complete
    [
      object&.funding_approved_on,
      object&.payment_bank_name,
      object&.payment_aba_routing_number,
      object&.payment_account_number,
      object&.payment_account_type,
      object&.payment_account_holder,
      object&.first_payment_date,
      object&.payment_first_day,
      object&.payment_frequency,
      object&.insurance&.company_name,
      object&.insurance&.property_damage,
      object&.insurance&.bodily_injury_per_person,
      object&.insurance&.bodily_injury_per_occurrence,
      object&.insurance&.comprehensive,
      object&.insurance&.collision,
      object&.insurance&.effective_date,
      object&.insurance&.expiration_date,
      object&.insurance&.policy_number,
    ].all?
  end

  def credit_status
    self.object.credit_status.humanize.titlecase
  end

  def credit_status_value
    self.object.credit_status
  end

  def documents_issued_date
    self.object&.documents_issued_date&.strftime("%m/%d/%Y")
  end

  def documents_requested_date
    self.object&.documents_requested_date&.strftime("%m/%d/%Y")
  end

  def dealership
    {
      dealership:                                   self.object&.dealership&.name,
      is_dealership_subject_to_clawback:            self.object&.is_dealership_subject_to_clawback, 
      this_deal_dealership_clawback_amount:         self.object&.this_deal_dealership_clawback_amount, 
      after_this_deal_dealership_clawback_amount:   self.object&.after_this_deal_dealership_clawback_amount
    }
  end

  def payment
    payment, label = calculate_payment_and_label
    {
      payment:                                   to_currency(payment),
      payment_bank_name:                         self.object&.payment_bank_name,
      payment_aba_routing_number:                self.object&.payment_aba_routing_number,
      payment_account_number:                    self.object&.payment_account_number,
      payment_account_type:                      self.object&.payment_account_type,
      payment_account_holder:                    self.object&.payment_account_holder,
      colessee_payment_bank_name:                self.object&.colessee_payment_bank_name,
      colessee_payment_aba_routing_number:       self.object&.colessee_payment_aba_routing_number,
      colessee_payment_account_number:           self.object&.colessee_payment_account_number,
      colessee_account_joint_to_lessee:          self.object&.colessee_account_joint_to_lessee,
      colessee_payment_account_type:             self.object&.colessee_payment_account_type,
      first_payment_date:                        self.object&.first_payment_date,
      payment_first_day:                         self.object&.payment_first_day,
      second_payment_date:                       self.object&.second_payment_date,
      payment_second_day:                        self.object&.payment_second_day,
      payment_frequency:                         self.object&.read_attribute_before_type_cast('payment_frequency'),
      payment_monthly_payment_label:             label,
      payment_term:                              self.object&.lease_calculator&.term
    }
  end

  def calculator
    {
      credit_tier:                        self.object&.lease_calculator&.credit_tier_v2&.description,
      calculator_id:                      self.object&.lease_calculator&.id,
      term:                               self.object&.lease_calculator&.term,
      adjusted_capitalized_cost_cents:    self.object&.lease_calculator&.adjusted_capitalized_cost_cents,
      customer_purchase_option_cents:     self.object&.lease_calculator&.customer_purchase_option_cents,
      refundable_security_deposit_cents:  self.object&.lease_calculator&.refundable_security_deposit_cents
    }
  end

  def vehicle
    {
      asset_make:                          self.object&.lease_calculator&.asset_make,
      asset_model:                         self.object&.lease_calculator&.asset_model,
      asset_year:                          self.object&.lease_calculator&.asset_year,
      asset_vin:                           self.object&.lease_calculator&.asset_vin,
      asset_color:                         self.object&.last_lease_document_request&.asset_color&.titleize,
      exact_odometer_mileage:              to_delimited(self.object&.last_lease_document_request&.exact_odometer_mileage),
      requested_date:                      object&.last_lease_document_request&.created_at&.strftime("%B %d, %Y")
    }
  end

  def docusign_histories
    return [] unless object&.docusign_summaries.present?

    object.docusign_summaries.map do |summary|
      {
        envelope_id: summary.envelope_id,
        envelope_status: summary.envelope_status,
        envelope_users: docusign_envelope_users(summary.docusign_histories.order('user_role'))
      }
    end
  end

  def docusign_envelope_users(envelope_users)
    envelope_users.map do |user|
      {
        name: user.user_name,
        role: user.user_role,
        email: user.user_email,
        status: user.user_status.to_s
      }
    end
  end

  def lease_application_welcome_call_form
    {
      assigned_department: Department.order(:id).map{|s| [s.description, s.id]}.to_h
    }
  end

  def document_status_options
    LeaseApplication.aasm(:document_status).states_for_select.map do |i|
      {
        option_name: i.first,
        option_value: i.last,
        selected: self.object.document_status == i.last,
        disabled: false
      }
    end
  end

  def payment_account_holder_options
    ["Lessee", "Co-Lessee", "Both"].map{|i| [i,i]}.to_h
  end

  def colessee_account_joint_to_lessee_options
    ["Yes", "No"].map{|i| [i,i]}.to_h
  end

  def payment_account_type_options
    ["Checking", "Savings"].map do |i|
      {
        option_name: i,
        option_value: i.downcase,
        selected: self.object.payment_account_type == i.downcase
      }
    end
  end

  def payment_frequency_options
    self.object.class.payment_frequencies.map do |key, value|
      {
        option_name: key.humanize,
        option_value: value,
        selected: self.object.payment_frequency == value
      }
    end
  end

  def prenote_status
    self.object.get_prenote_status.humanize
  end

  def mail_carrier_options
    MailCarrier.all.map do |carrier|
      {
        option_name: carrier.description,
        option_value: carrier.id,
        selected: object.mail_carrier_id == carrier.id
      }
    end
  end

  def payment_info_exists
    object&.payment_info_exists
  end

  def prenote_status
    object&.prenotes&.last&.prenote_status&.humanize
  end

  def stipulation_lease_application_attachments
    object&.lease_application_attachments.collect { |x| [x.read_attribute(:upload), x.id] }
  end

  def credit_status_options
    LeaseApplication.aasm(:credit_status).states_for_select.map do |i|
      {
        option_name: i.first,
        option_value: i.last,
        selected: self.object.credit_status == i.last,
        disabled: is_disable_credit_status_approved(i.last)
      }
    end
  end

  def workflow_status_options
    WorkflowStatus.all.map do |i|
      {
        option_name: i.description,
        option_value: i.id,
        selected: self.object.workflow_status == i,
        disabled: false
      }
    end
  end

  def workflow_status_description
    object&.workflow_status&.description
  end

  def credit_reports
    ActiveModelSerializers::SerializableResource.new(CreditReport.where(lessee_id: [object&.lessee&.id, object&.colessee&.id].compact)) || []
  end

  def lessee_credit_summary
    lessee = object&.lessee
    credit_summary(lessee)
  end

  def colessee_credit_summary
    lessee = object&.colessee
    credit_summary(lessee)
  end

  def credit_average_summary
    payment_limit = object&.lease_application_payment_limits&.last
    payment_limit_percentage = payment_limit&.credit_tier&.payment_limit_percentage&.to_i
    {
      proven_monthly_income: to_currency(payment_limit&.proven_monthly_income),
      payment_limit_percentage: "%#{payment_limit_percentage}",
      max_allowable_payment: to_currency(payment_limit&.max_allowable_payment),
      override_max_allowable_payment: to_currency(payment_limit&.override_max_allowable_payment),
      total_monthly_payment: to_currency(payment_limit&.total_monthly_payment),
      variance: to_currency(payment_limit&.variance),
      override_variance: to_currency(payment_limit&.override_variance),
      is_variance_negative: payment_limit&.variance&.negative?,
      payment_limit_id: payment_limit&.id,
      average_credit_score: object&.lease_application_recommended_credit_tiers&.last&.average_score&.round,
      blackbox_average_credit_score: object&.lease_application_recommended_blackbox_tiers&.last&.average_score&.round,
      recommended_credit_tier: object&.lease_application_recommended_credit_tiers&.last&.credit_tier&.description,
      recommended_blackbox_tier: object&.lease_application_recommended_blackbox_tiers&.last&.blackbox_model_detail&.tier_label,
      approved_credit_tier: object&.lease_calculator&.credit_tier_record&.description
    }
  end

  def audits
      Admins::AuditDecorator.wrap(object&.retrieve_audits).map do |i|
        {
          date: i.created_at_ui_format,
          audited: display_name(i.audited),
          by_who: i.user == "System" ? i.user : i.user.full_name,
          changes: i.audited_changes,
        }
      end
  end

  # def lease_application_gps_units
  #   ActiveModelSerializers::SerializableResource.new(LeaseApplicationGpsUnit.where(lease_application_id: [object&.id].compact).last, 
  #     key_transform: :camel_lower,
  #     adapter: :json,
  #     root: false
  #   ) || []
  #   #ActiveModelSerializers::SerializableResource.new( myquery ,adapter: :json, root: "myRoot", key_transform: :camel_lower).to_json
  # end


  def attachment_category_options
    FileAttachmentType.all.map{ |i| { label: i.label, value: i.id } }
  end

  def income_verification_record_options
    record = IncomeVerification.where(lessee_id: [object&.lessee&.id, object&.colessee&.id].compact)
    record.map{ |i| { label: "#{i&.employer_client} (#{i&.lessee&.full_name})", value: i.id } }
  end

  def income_frequency_options
    IncomeFrequency.limit(1000).map do |record|
      {
        option_value: record.id,
        option_name: record.income_frequency_name
      }
    end
  end

  def deleted_colessees
    object&.deleted_colessees.map do |lessee|
      {
        full_name: lessee.full_name,
        deleted_at: lessee.deleted_at.strftime("%B %d, %Y"),
        email_address: lessee.email_address
      }
    end
  end

  def income_verification_type_options
    IncomeVerificationType.limit(1000).map do |record|
      {
        option_value: record.id,
        option_name: record.income_verification_name
      }
    end
  end

  def lease_verification_call
    {
      call_exists: object&.online_verification_call_checklist&.present? || false,
      issue: object&.online_verification_call_checklist&.issue || false
    }
  end

  def decline_reason_type_options
    DeclineReasonType.all.map do |record|
      {
        option_value: record.id,
        option_name: record.decline_reason_name
      }
    end
  end

  def notifications
    {
      credit_decision_emails_count: object&.notifications&.credit_decision_emails&.count
    }
  end

  def action_permission
    decorated_object = LeaseApplicationDecorator.new(object)

    return {
      can_send_credit_decision: decorated_object&.can_send_credit_decision?
    }
  end

  private

  def display_name(val)
    val.try(:display_name) || val.try(:full_name) || val.try(:name) || val.try(:username) || val.try(:login) || val.try(:title) || val.try(:email) || val.try(:model_name).try(:human) || val.try(:to_s)
  end

  def calculate_payment_and_label
    payment   = self.object&.lease_calculator&.total_monthly_payment
    frequency = self.object&.payment_frequency
    if( frequency == "split")
      _payment = ( payment * 0.5).round(2)
      _label   = 'Twice per Month'
    elsif(self.object.payment_frequency == "full")
      _label   = 'Monthly'
      _payment = payment
    else
      _label   = 'One Time'
      _payment = payment
    end
    return _payment, _label
  end

  def to_currency(val)
    ActionController::Base.helpers.number_to_currency(val)
  end

  def to_delimited(val)
    ActiveSupport::NumberHelper::number_to_delimited(val)
  end

  # def credit_summary(lessee)
  #   report = lessee&.credit_reports&.order(:id)&.last
  #   blackbox = object.lease_application_blackbox_requests.where(lessee_id: lessee&.id).last
  #   leadrouter_credit_score = blackbox&.leadrouter_credit_score.nil? ? 0 : blackbox&.leadrouter_credit_score
    
  #   {
  #     name: lessee&.full_name,
  #     credit_score_equifax: report&.credit_score_equifax,
  #     credit_score_experian: report&.credit_score_experian,
  #     credit_score_transunion: report&.credit_score_transunion,
  #     credit_score_average: report&.credit_score_average.nil? ? 0 : report.credit_score_average,
  #     blackbox_decision: blackbox&.leadrouter_response.nil? ? "" : blackbox&.leadrouter_response["decision"],
  #     leadrouter_credit_score: leadrouter_credit_score,
  #     recommended_credit_tier: lessee&.lease_application_recommended_credit_tiers&.last&.credit_tier&.description,
  #     recommended_blackbox_tier: lessee&.lease_application_recommended_blackbox_tiers&.last&.blackbox_model_detail&.tier_label,
  #     approved_credit_tier: object&.lease_calculator&.credit_tier_record&.description
  #   }
  # end

  def credit_summary(lessee)
    report = lessee&.credit_reports&.order(:id)&.last
    blackbox = object.lease_application_blackbox_requests.where(lessee_id: lessee&.id).last
    blackbox_tier = blackbox&.lessee_recommended_blackbox_tier&.blackbox_model_detail&.blackbox_tier
    leadrouter_credit_score = blackbox&.leadrouter_credit_score.nil? ? 0 : blackbox&.leadrouter_credit_score
    credit_score_average = report&.credit_score_average.nil? ? 0 : report.credit_score_average

    # blackboox_credit_scores = [
    #   leadrouter_credit_score
    # ].compact.select{|x| x != 0 }
    {
      name: lessee&.full_name,
      credit_score_equifax: report&.credit_score_equifax,
      credit_score_experian: report&.credit_score_experian,
      credit_score_transunion: report&.credit_score_transunion,
      credit_score_average: credit_score_average,
      blackbox_decision: blackbox&.leadrouter_response.nil? ? "" : blackbox&.leadrouter_response["decision"],
      leadrouter_credit_score: leadrouter_credit_score,
      # recommended_credit_tier: blackbox&.recommended_credit_tier.nil? ? 0 : blackbox&.recommended_credit_tier&.credit_tier&.description,
      recommended_credit_tier: get_recommended_credit_score(credit_score_average),
      recommended_blackbox_tier: blackbox_tier.nil? ? "" : "Tier #{blackbox_tier}"
    }
  end

  def get_recommended_credit_score(scores)
    recommended_credit_tier_position = LeaseApplication.credit_tier_range(scores&.round)
    CreditTier.all.select{|c| c.description.split(' ')[1].to_i == recommended_credit_tier_position }&.first&.description
  end


  def is_disable_credit_status_approved(value)
    return true if object&.is_disable_credit_status_approved && value == 'approved'
    false
  end
end