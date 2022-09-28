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

FactoryBot.define do
  factory :lease_calculator do
    asset_make { 'Harley-Davidson' }
    asset_model { 'FXDC' }
    asset_year { 2017 }
    condition { :used }
    mileage_tier { "10000" }
    credit_tier { "Tier 1 (FICO 850-790)" }
    term { 24 }
    tax_jurisdiction { "Dade County, Florida" }
    us_state { :florida } #must be in the list of Enums
    nada_retail_value_cents { 30000 }
    customer_purchase_option_cents { 30000 }
    dealer_sales_price_cents { 30000 }
    dealer_freight_and_setup_cents { 30000 }
    total_dealer_price_cents { 30000 }
    upfront_tax_cents { 30000 }
    title_license_and_lien_fee_cents { 30000 }
    dealer_documentation_fee_cents { 30000 }
    guaranteed_auto_protection_cost_cents { 30000 }
    prepaid_maintenance_cost_cents { 30000 }
    extended_service_contract_cost_cents { 30000 }
    tire_and_wheel_contract_cost_cents { 30000 }
    gps_cost { 30000 }
    fi_maximum_total_cents { 30000 }
    total_sales_price_cents { 30000 }
    gross_trade_in_allowance_cents { 30000 }
    trade_in_payoff_cents { 30000 }
    net_trade_in_allowance_cents { 30000 }
    rebates_and_noncash_credits_cents { 30000 }
    cash_down_payment_cents { 30000 }
    cash_down_minimum_cents { Money.zero }
    acquisition_fee_cents { 30000 }
    adjusted_capitalized_cost_cents { 30000 }
    base_monthly_payment_cents { 30000 }
    monthly_sales_tax_cents { 30000 }
    total_monthly_payment_cents { 30000 }
    refundable_security_deposit_cents { 30000 }
    total_cash_at_signing_cents { 30000 }
    minimum_reserve_cents { 30000 }
    dealer_reserve_cents { 30000 }
    monthly_depreciation_charge_cents { 30000 }
    monthly_lease_charge_cents { 30000 }
    remit_to_dealer_cents { 30000 }
    dealer_participation_markup { 1.500 } #1.5 percent
    servicing_fee_cents { 15000 }
    pre_tax_payments_sum_cents { 720000 }
  end
end
