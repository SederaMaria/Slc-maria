# == Schema Information
#
# Table name: lease_document_requests
#
#  id                      :integer          not null, primary key
#  lease_application_id    :integer
#  asset_make              :string
#  asset_model             :string
#  asset_year              :integer
#  asset_vin               :string
#  asset_color             :string
#  exact_odometer_mileage  :string
#  trade_in_make           :string
#  trade_in_model          :string
#  trade_in_year           :string
#  delivery_date           :date
#  gap_contract_term       :integer          default(0)
#  service_contract_term   :integer          default(0)
#  ppm_contract_term       :integer          default(0)
#  tire_contract_term      :integer          default(0)
#  equipped_with           :string
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  manual_vin_verification :boolean
#
# Indexes
#
#  index_lease_document_requests_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

class LeaseDocumentRequest < ApplicationRecord
  include SimpleAudit::Model
  simple_audit
  
  before_save :upcase_asset_vin, if: :saved_change_to_asset_vin?

  belongs_to :lease_application
  belongs_to :model_year

  has_one :vin_validation,
    as: :validatable

  has_one :lease_calculator,
    -> {readonly},
    through: :lease_application

  validates :asset_vin, :asset_color, :exact_odometer_mileage, :delivery_date, presence: true

  validates :trade_in_year, :trade_in_model, :trade_in_make,
    presence: true,
    if: :trade_allowance_greater_than_zero?

  validates :service_contract_term,
    presence: true,
    numericality: { greater_than: 0, only_integer: true, allow_nil: true},
    if: :extended_service_contract_greater_than_zero?

  validates :tire_contract_term,
    presence: true,
    numericality: { greater_than: 0, only_integer: true, allow_nil: true},
    if: :tire_contract_greater_than_zero?

  validates :ppm_contract_term,
    presence: true,
    numericality: { greater_than: 0, only_integer: true, allow_nil: true},
    if: :ppm_contract_greater_than_zero?

  after_create :set_model_year
  after_update :set_model_year
  
  def general_description
    "#{asset_year} #{asset_make} #{asset_model}"
  end

  def trade_allowance_greater_than_zero?
    lease_calculator&.net_trade_in_allowance_cents.to_i > 0
  end

  def extended_service_contract_greater_than_zero?
    lease_calculator&.extended_service_contract_cost_cents.to_i > 0
  end

  def tire_contract_greater_than_zero?
    lease_calculator&.tire_and_wheel_contract_cost_cents.to_i > 0
  end

  def ppm_contract_greater_than_zero?
    lease_calculator&.prepaid_maintenance_cost_cents.to_i > 0
  end
  
  def retrieve_audits
    Audit.where(audited_id: id, audited_type: "LeaseDocumentRequest").limit(1000).sort { |a, b| b.created_at <=> a.created_at }
  end

  def upcase_asset_vin
    asset_vin.upcase!
  end

  def model_year_record
    @model_year_record ||= ModelYear.active.for_make_model_and_year(asset_make, asset_model, asset_year).first
  end

  def set_model_year
    update_column(:model_year_id, model_year_record&.id) unless model_year_record.nil?
  end

end
