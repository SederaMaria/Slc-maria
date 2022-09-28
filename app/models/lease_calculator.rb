# == Schema Information
#
# Table name: lease_calculators
#
#  id                                    :integer          not null, primary key
#  asset_make                            :string
#  asset_model                           :string
#  asset_year                            :integer
#  condition                             :integer
#  mileage_tier                          :string
#  credit_tier                           :string
#  term                                  :integer
#  tax_jurisdiction                      :string
#  us_state                              :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  nada_retail_value_cents               :integer          default(0), not null
#  customer_purchase_option_cents        :integer          default(0), not null
#  dealer_sales_price_cents              :integer          default(0), not null
#  dealer_freight_and_setup_cents        :integer          default(0), not null
#  total_dealer_price_cents              :integer          default(0), not null
#  upfront_tax_cents                     :integer          default(0), not null
#  title_license_and_lien_fee_cents      :integer          default(0), not null
#  dealer_documentation_fee_cents        :integer          default(0), not null
#  guaranteed_auto_protection_cost_cents :integer          default(0), not null
#  prepaid_maintenance_cost_cents        :integer          default(0), not null
#  extended_service_contract_cost_cents  :integer          default(0), not null
#  tire_and_wheel_contract_cost_cents    :integer          default(0), not null
#  gps_cost_cents                        :integer          default(0), not null
#  fi_maximum_total_cents                :integer          default(0), not null
#  total_sales_price_cents               :integer          default(0), not null
#  gross_trade_in_allowance_cents        :integer          default(0), not null
#  trade_in_payoff_cents                 :integer          default(0), not null
#  net_trade_in_allowance_cents          :integer          default(0), not null
#  rebates_and_noncash_credits_cents     :integer          default(0), not null
#  cash_down_payment_cents               :integer          default(0), not null
#  cash_down_minimum_cents               :integer          default(0), not null
#  acquisition_fee_cents                 :integer          default(0), not null
#  adjusted_capitalized_cost_cents       :integer          default(0), not null
#  base_monthly_payment_cents            :integer          default(0), not null
#  monthly_sales_tax_cents               :integer          default(0), not null
#  total_monthly_payment_cents           :integer          default(0), not null
#  refundable_security_deposit_cents     :integer          default(0), not null
#  total_cash_at_signing_cents           :integer          default(0), not null
#  minimum_reserve_cents                 :integer          default(20000), not null
#  dealer_reserve_cents                  :integer          default(0), not null
#  monthly_depreciation_charge_cents     :integer          default(0), not null
#  monthly_lease_charge_cents            :integer          default(0), not null
#  remit_to_dealer_cents                 :integer          default(0), not null
#  dealer_participation_markup           :decimal(3, 2)    default(0.0)
#  servicing_fee_cents                   :integer          default(0), not null
#  backend_max_advance_cents             :integer          default(0), not null
#  frontend_max_advance_cents            :integer          default(0), not null
#  backend_total_cents                   :integer          default(0), not null
#  frontend_total_cents                  :integer          default(0), not null
#  ga_tavt_value_cents                   :integer          default(0), not null
#  pre_tax_payments_sum_cents            :integer          default(0), not null
#  original_msrp_cents                   :integer          default(0), not null
#  nada_rough_value_cents                :integer          default(0), not null
#  new_used                              :string
#  notes                                 :string
#  acc_less_fi_less_af_cents             :integer          default(0), not null
#  credit_tier_id                        :bigint(8)
#  dealer_shortfund_amount_cents         :integer          default(0), not null
#  remit_to_dealer_less_shortfund_cents  :integer          default(0), not null
#
# Indexes
#
#  index_lease_calculators_on_credit_tier_id  (credit_tier_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_tier_id => credit_tiers.id)
#

class LeaseCalculator < ApplicationRecord
  include ActiveAdmin::LeaseCalculatorHelper
  include ActionView::Helpers::FormOptionsHelper
  include SimpleAudit::Model
  simple_audit child: true

  TERMS = [24, 36, 48, 60].freeze
  DEFAULT_TERM = 24

  enum condition: {:used => 0, :new => 1}, _prefix: "condition"

  has_one :lease_application
  belongs_to :model_year
  belongs_to :credit_tier_v2, class_name: 'CreditTier', foreign_key: :credit_tier_id

  has_one :lessee,
    through: :lease_application
  
  has_one :colessee,
    through: :lease_application

  has_many :lease_application_stipulations,
    through: :lease_application
  
  has_many :stipulations,
    through: :lease_application

  delegate :submitted?, to: :lease_application, allow_nil: true

  scope :submittable, -> { where.not(us_state: nil, tax_jurisdiction: nil, asset_make: nil, asset_year: nil, asset_model: nil, mileage_tier: nil) }
  
  scope :with_monthly_payments_greater_than_zero, -> {
    where(arel_table[:total_monthly_payment_cents].gt(0))
  }

  scope :without_monthly_payments_greater_than_zero, -> {
    where(arel_table[:total_monthly_payment_cents].lteq(0))
  }

  after_update :save_credit_tier_id, if: :saved_change_to_credit_tier?
  after_update :clear_vin, if: -> (obj){ (obj.saved_change_to_asset_make? or obj.saved_change_to_asset_model? or obj.saved_change_to_asset_year?) && !obj.saved_change_to_asset_vin? }
  after_update :update_shortfund
  after_update :set_model_year
  after_update :run_payment_limit_job

  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end

  def sum_of_all_payments
    total_monthly_payment * term
  end

  def total_at_sign
    [total_cash_at_signing, rebates_and_noncash_credits, net_trade_in_allowance].sum
  end

  def lease_total_payments
    deposition_fee = Money.new(19900, 'USD')
    total_at_sign + sum_of_all_payments + deposition_fee - total_monthly_payment - refundable_security_deposit
  end

  def total_rent_charge
    pre_tax_payments_sum - (adjusted_capitalized_cost - customer_purchase_option)
  end

  def remaining_payments_at_signing
    term.to_i - 1
  end

  def balance_due_on_motorcycle_deal
    total_sales_price -
    net_trade_in_allowance -
    cash_down_payment -
    total_monthly_payment -
    refundable_security_deposit -
    servicing_fee
  end

  def has_guaranteed_auto_protection?
    guaranteed_auto_protection_cost_cents > 0
  end

  def display_name
    "#{asset_year || '20??'} #{asset_model || 'Bike'} in #{tax_jurisdiction || 'TBD'}"
  end

  def recalculate
    LeaseRecalculator.new(lease_calculator: self).recalculate
  end

  def update_total_cash_signin input
    LeaseRecalculator.new(lease_calculator: self)
  end

  def select_options
      {
        asset_model: options_for_select(
          model_years_for_make_and_year_for_select(
            asset_make: asset_make, 
            asset_year: asset_year), asset_model),
        dealer_participation_markup: participation_markup_for_select(credit_tier: credit_tier_v2&.description)
      }
  end

  def errors_for_json_response
    valid? ? '' : errors.full_messages.collect {|m| "<li>#{m}</li>"}
  end

  def maximum_term_length
    model_group_record&.maximum_term_length || LeaseCalculator::TERMS.max
  end

  def tax_jurisdiction_collection_options
    us_state.present? ? TaxJurisdiction.where(us_state: us_state).order(:name).pluck(:name) : []
  end

  def model_year_record
    @model_year_record ||= ModelYear.active.for_make_model_and_year(asset_make, asset_model, asset_year).first
  end

  def mileage_tier_record
    return nil unless mileage_tier
    lower, upper = mileage_tier.split(' - ').map(&:to_i)
    @mileage_tier_record ||= MileageTier.where(lower: lower, upper: upper).first
  end

  def model_group_record
    @model_group_record ||= model_year_record&.model_group
  end

  def credit_tier_record
    if credit_tier_v2.nil?
      @credit_tier_record ||= CreditTier.for_make_name(asset_make).where(description: credit_tier ).first
    else
      @credit_tier_record ||= credit_tier_v2
    end
  end


  def credit_tier_record_by_model_year
    @credit_tier_record ||= CreditTier.for_make_name(asset_make).where(description: credit_tier, model_group_id: model_group_record&.id ).first
  end

  def credit_tier_number
    return nil if credit_tier.blank?
    credit_tier.split(' ').second
  end

  def locked?
    lease_application && lease_application.document_status != 'no_documents'
  end

  #TWO methods to help with calculating a couple of fields that are not
  #being saved into the database explicitly.
  #TODO - incorporate these into the calculator and give them an actual monetized DB field
  def calculate_gross_capitalized_cost
    adjusted_capitalized_cost + calculate_capitalized_cost_reduction
  end

  def calculate_capitalized_cost_reduction
    cash_down_payment + net_trade_in_allowance
  end

  def gross_capitalized_cost_cents_lpc
    dealer_sales_price_cents + 
    upfront_tax_cents + 
    title_license_and_lien_fee_cents + 
    extended_service_contract_cost_cents + 
    dealer_documentation_fee_cents + 
    acquisition_fee_cents + 
    guaranteed_auto_protection_cost_cents + 
    tire_and_wheel_contract_cost_cents +
    prepaid_maintenance_cost_cents +
    gps_cost_cents
  end

  def capitalized_cost_reduction_cents_lpc
    cash_down_payment_cents + 
    net_trade_in_allowance_cents - 
    total_monthly_payment_cents - 
    servicing_fee_cents - 
    refundable_security_deposit_cents
  end

  def adjusted_capitalized_cost_cents_lpc
    gross_capitalized_cost_cents_lpc - capitalized_cost_reduction_cents_lpc
  end

  def rate_calc_result
    rate = rate_finder(term, base_monthly_payment_cents, -adjusted_capitalized_cost_cents_lpc, customer_purchase_option_cents)
    ((1 + rate) ** 12) - 1
  end

  def rate_finder(periods, payment, present, future = 0, type = 0, guess = 0.01)

    # Set maximum epsilon for end of iteration
    eps_max = 1e-10

    # Set maximum number of iterations
    iter_max = 10

    # Implement Newton's method
    y = y0 = y1 = x0 = x1 = f = i = 0
    rate = guess

    if rate.abs < eps_max
      y = present * (1 + periods * rate) + payment * (1 + rate * type) * periods + future
    else
      f = Math.exp(periods * Math.log(1 + rate))
      y = present * f + payment * (1 / rate + type) * (f - 1) + future
    end

    y0 = present + payment * periods + future
    y1 = present * f + payment * (1 / rate + type) * (f - 1) + future
    i = x0 = 0
    x1 = rate

    while (((y0 - y1).abs > eps_max) && (i < iter_max))
      rate = (y1 * x0 - y0 * x1) / (y1 - y0)
      x0 = x1
      x1 = rate

      if rate.abs < eps_max
        y = present * (1 + periods * rate) + payment * (1 + rate * type) * periods + future
      else
        f = Math.exp(periods * Math.log(1 + rate))
        y = present * f + payment * (1 / rate + type) * (f - 1) + future
      end

      y0 = y1
      y1 = y
      ++i
    end

    rate
  end

  # Convert rate to format for LeasePak
  def npv_discount_rate_calc(num, multiplier)
    result = sprintf '%.5f', (num * multiplier)
    result
  end

  def npv_discount_rate
    npv_discount_rate_calc(rate_calc_result, 100)
  end

  def save_credit_tier_id
    if !credit_tier.nil? && credit_tier.present?
      # Update only if `credit_tier_id` is absent
      update_column(:credit_tier_id, credit_tier_record_by_model_year.id) unless credit_tier_id.present?
    end
  end

  def update_shortfund
    is_initial_value_zero = (dealer_shortfund_amount + lease_application&.this_deal_dealership_clawback_amount.to_money) == 0
    is_remit_to_dealer_less_shortfund_zero = remit_to_dealer_less_shortfund == 0
    is_not_same_value = (lease_application&.this_deal_dealership_clawback_amount.to_money !=  dealer_shortfund_amount)
    this_deal_dealership_clawback_amount = lease_application&.this_deal_dealership_clawback_amount.nil? ? 0 : lease_application&.this_deal_dealership_clawback_amount&.to_money&.cents
    if is_not_same_value || is_initial_value_zero || is_remit_to_dealer_less_shortfund_zero
      update_column(:dealer_shortfund_amount_cents, this_deal_dealership_clawback_amount)
      update_column(:remit_to_dealer_less_shortfund_cents, (remit_to_dealer - dealer_shortfund_amount).cents)
    end
  end

  def set_model_year
    update_column(:model_year_id, model_year_record&.id) unless model_year_record.nil?
  end

  def clear_vin
    if (asset_make_was != nil) || (asset_model != nil) || (asset_year != nil)
      update_column(:asset_vin, "")
    end
  end

  def run_payment_limit_job
    PaymentLimitJob.perform_async(self.lease_application.id) unless self.lease_application.application_identifier.nil?
  end

end
