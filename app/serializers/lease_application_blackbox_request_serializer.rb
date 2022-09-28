# == Schema Information
#
# Table name: lease_application_blackbox_requests
#
#  id                               :bigint(8)        not null, primary key
#  lease_application_id             :integer
#  leadrouter_response              :string
#  leadrouter_credit_score          :float
#  leadrouter_suggested_corrections :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  leadrouter_lead_id_int           :integer
#  leadrouter_request_body          :string
#  lessee_id                        :bigint(8)
#  leadrouter_lead_id               :uuid
#  blackbox_endpoint                :string
#  reject_stage                     :integer
#
# Indexes
#
#  index_lease_application_blackbox_requests_on_lessee_id  (lessee_id)
#
# Foreign Keys
#
#  fk_rails_...  (lessee_id => lessees.id)
#

class LeaseApplicationBlackboxRequestSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers
  attributes :id, :first_name, :last_name, :employer, :title, :employment_status, :employment_informaton_datax_path, :lessee_id,
            :name, :decision, :adjusted_score, :suggested_correction, :created_at, :updated_at, :blackbox_endpoint, :application_identifier,
            :updated_at_unformatted, :lease_application_id, :request_control, :request_event_source, :employee_ssn, :employment_start_date,
            :total_months_with_employer, :termination_date, :rate_of_pay, :annualized_income, :pay_frequency, :pay_period_frequency, 
            :average_hours_worked_per_pay_period, :middle_name
  
  has_many :lease_application_blackbox_adverse_reasons
  has_many :lease_application_blackbox_tlo_person_search_addresses, serializer: LeaseApplicationBlackboxTloPersonSearchAddressSerializer
  has_many :lease_application_blackbox_errors
  has_many :lease_application_blackbox_employment_searches

  def first_name
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["EmployeeFirstName"] rescue ''
  end

  def last_name
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["EmployeeLastName"] rescue ''
  end

  def middle_name
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["EmployeeMiddleName"] rescue ''
  end

  def employer
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["EmployerName"] rescue ''
  end

  def title
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["PositionTitle"] rescue ''
  end

  def employment_status
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["EmploymentStatus"] rescue ''
  end

  def employee_ssn
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["EmployeeSSN"] rescue ''
  end

  def employment_start_date
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["EmploymentStartDate"] rescue ''
  end

  def total_months_with_employer
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["TotalMonthsWithEmployer"] rescue ''
  end

  def termination_date
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["TerminationDate"] rescue ''
  end

  def rate_of_pay
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["RateOfPay"] rescue ''
  end

  def annualized_income
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["AnnualizedIncome"] rescue ''
  end

  def pay_frequency
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["PayFrequency"] rescue ''
  end

  def pay_period_frequency
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["PayPeriodFrequency"] rescue ''
  end

  def average_hours_worked_per_pay_period
    JSON.parse(object.leadrouter_response.to_json)["extraAttributes"]["twn_raw_report"]["DataxResponse"]["TWNSelectSegment"]["AverageHoursWorkedPerPayPeriod"] rescue ''
  end

  def employment_informaton_datax_path
    employment_information_admins_lease_application_blackbox_request_path(object)
  end

  def name
    object&.lessee&.full_name
  end

  def decision
    object.leadrouter_response["decision"]
  end

  def adjusted_score
    object.leadrouter_credit_score
  end

  def suggested_correction
    object.leadrouter_suggested_corrections
  end

  def blackbox_endpoint
    object&.blackbox_endpoint&.sub!("-"," ")&.titleize
  end

  def created_at
    object&.created_at&.strftime('%B %-d %Y at %r %Z')
  end

  def updated_at
      object&.updated_at&.strftime('%B %-d %Y at %r %Z')
  end

  def updated_at_unformatted
    object&.updated_at
  end

  def application_identifier
    object&.lease_application&.application_identifier
  end

  def request_control
    object&.request_control&.titleize
  end
end