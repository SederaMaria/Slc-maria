module Calculators
  class AlabamaUpfrontTaxCalculator < UpfrontTaxCalculator
    attr_accessor :state_upfront_tax_percentage, :county_upfront_tax_percentage, :local_upfront_tax_percentage,
                  :cash_down_payment, :gross_trade_in_allowance

    calculate(:upfront_tax) { [Money.zero, total_upfront_tax].max }

    calculate(:total_upfront_tax) do
      state_upfront_tax + county_upfront_tax + local_upfront_tax
    end

    calculate(:state_upfront_tax) do
      (cash_down_payment_or_zero + gross_trade_in_allowance_or_zero) * state_upfront_tax_rate
    end

    calculate(:county_upfront_tax) do
      (cash_down_payment_or_zero + gross_trade_in_allowance_or_zero) * county_upfront_tax_rate
    end

    calculate(:local_upfront_tax) do
      (cash_down_payment_or_zero + gross_trade_in_allowance_or_zero) * local_upfront_tax_rate
    end

    calculate(:gross_trade_in_allowance_or_zero) do
      [Money.zero, gross_trade_in_allowance].max
    end
  end
end