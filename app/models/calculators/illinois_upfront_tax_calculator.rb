module Calculators
  class IllinoisUpfrontTaxCalculator < UpfrontTaxCalculator
    attr_accessor :state_upfront_tax_percentage, :county_upfront_tax_percentage,
                  :cash_down_payment, :gross_trade_in_allowance,
                  :trade_in_payoff, :guaranteed_auto_protection_cost,
                  :prepaid_maintenance_cost, :extended_service_contract_cost,
                  :tire_and_wheel_contract_cost, :dealer_sales_price,
                  :dealer_documentation_fee, :acquisition_fee, :dealer_freight_and_setup,
                  :customer_purchase_option, :money_factor,
                  :term, :local_upfront_tax_percentage, :gps_cost

    calculate(:upfront_tax) {(dealer_sales_price + dealer_freight_and_setup + dealer_documentation_fee + gps_cost) * combined_tax_rates}

    calculate(:total_upfront_tax) do
      tax_on_payments + tax_on_cash_and_trade_allowance
    end

    calculate(:tax_on_payments) do
      pre_tax_payments_monthly_sum * combined_tax_rates
    end

    calculate(:tax_on_cash_and_trade_allowance) do
      tax_on_cash
    end

    calculate(:tax_on_cash) do
      if cash_down_payment.positive?
        cash_down_payment * combined_tax_rates
      else
        Money.zero
      end
    end

    calculate(:pre_tax_payments_sum) do
      pre_tax_payments_monthly_sum + taxable_cap_cost_reduction
    end

    calculate(:taxable_cap_cost_reduction) do
      if cash_down_payment > 0
        cash_down_payment
      else
        Money.zero
      end
    end

    calculate(:cap_cost_reduction) do
      gross_trade_in_allowance - trade_in_payoff + cash_down_payment
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
      pre_tax_gross_cap - cap_cost_reduction
    end

    calculate(:pre_tax_gross_cap) do
      guaranteed_auto_protection_cost +
        prepaid_maintenance_cost +
        extended_service_contract_cost +
        tire_and_wheel_contract_cost +
        gps_cost +
        dealer_sales_price +
        dealer_documentation_fee +
        acquisition_fee +
        dealer_freight_and_setup
    end

    calculate(:net_trade_in_allowance) do
      trade_in_payoff - gross_trade_in_allowance
    end

    calculate(:combined_tax_rates) do
      (county_upfront_tax_percentage + state_upfront_tax_percentage + local_upfront_tax_percentage) / 100
    end
  end
end
