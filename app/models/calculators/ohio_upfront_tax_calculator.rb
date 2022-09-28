module Calculators
  class OhioUpfrontTaxCalculator < UpfrontTaxCalculator
    attr_accessor :state_upfront_tax_percentage, :county_upfront_tax_percentage,
                  :cash_down_payment, :gross_trade_in_allowance,
                  :trade_in_payoff, :guaranteed_auto_protection_cost,
                  :prepaid_maintenance_cost, :extended_service_contract_cost,
                  :tire_and_wheel_contract_cost, :dealer_sales_price,
                  :title_license_and_lien_fee, :dealer_documentation_fee,
                  :acquisition_fee, :dealer_freight_and_setup,
                  :customer_purchase_option, :money_factor,
                  :term, :gps_cost

    calculate(:upfront_tax) { [Money.zero, total_upfront_tax].max }

    calculate(:total_upfront_tax) do
      tax_on_payments + tax_on_cash_and_trade_allowance
    end

    calculate(:tax_on_payments) do
      pre_tax_payments_monthly_sum * combined_state_county_tax_rates
    end

    calculate(:tax_on_cash_and_trade_allowance) do
      tax_on_trade_allowance + tax_on_cash
    end

    calculate(:tax_on_trade_allowance) do
      if gross_trade_in_allowance.positive?
        gross_trade_in_allowance * combined_state_county_tax_rates
      else
        Money.zero
      end
    end

    calculate(:tax_on_cash) do
      if cash_down_payment.positive?
        cash_down_payment * combined_state_county_tax_rates
      else
        Money.zero
      end
    end

    calculate(:pre_tax_payments_sum) do
      pre_tax_payments_monthly_sum + taxable_cap_cost_reduction
    end

    calculate(:taxable_cap_cost_reduction) do
      gross_trade_in_allowance + (cash_down_payment > Money.zero ? cash_down_payment : Money.zero)
    end

    calculate(:pre_tax_payments_monthly_sum) do
      pre_tax_monthly_payment * term
    end

    calculate(:pre_tax_monthly_payment) do
      monthly_depreciation_charge + monthly_lease_charge
    end

    calculate(:monthly_depreciation_charge) do
      (pre_tax_adjusted_cap - customer_purchase_option) / term
    end

    calculate(:monthly_lease_charge) do
      (pre_tax_adjusted_cap + customer_purchase_option) * money_factor
    end

    calculate(:pre_tax_adjusted_cap) do
      pre_tax_gross_cap - cash_down_payment - gross_trade_in_allowance + trade_in_payoff
    end

    calculate(:pre_tax_gross_cap) do #
      guaranteed_auto_protection_cost +
        prepaid_maintenance_cost +
        extended_service_contract_cost +
        tire_and_wheel_contract_cost +
        gps_cost +
        dealer_sales_price +
        title_license_and_lien_fee +
        dealer_documentation_fee +
        acquisition_fee +
        dealer_freight_and_setup
    end

    calculate(:net_trade_in_allowance) do
      trade_in_payoff - gross_trade_in_allowance
    end

    calculate(:combined_state_county_tax_rates) do
      county_upfront_tax_rate + state_upfront_tax_rate
    end
  end
end
