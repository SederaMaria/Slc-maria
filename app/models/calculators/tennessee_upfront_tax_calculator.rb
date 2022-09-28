module Calculators
  class TennesseeUpfrontTaxCalculator < UpfrontTaxCalculator

    #CONVERT TO SETTINGS?
    SINGLE_ITEM_TAX_RATE = 0.0275.freeze #2.25%
    SINGLE_ITEM_CEILING  = 1600.to_money.freeze

    attr_accessor :state_upfront_tax_percentage,
                  :county_upfront_tax_percentage,
                  :cash_down_payment,
                  :dealer_sales_price

    #The Upfront Tax (really **any** tax) can never be negative.
    calculate(:upfront_tax) { [Money.zero, total_upfront_tax].max }

    calculate(:total_upfront_tax) do
      state_upfront_tax + 
      county_upfront_tax + 
      state_single_item_tax + 
      county_single_item_tax
    end

    calculate(:state_upfront_tax) do
      cash_down_payment_or_zero * state_upfront_tax_rate
    end

    calculate(:county_upfront_tax) do
      cash_down_payment_or_zero * county_upfront_tax_rate
    end

    calculate(:state_single_item_tax) do
      [SINGLE_ITEM_CEILING, dealer_sales_price].min * SINGLE_ITEM_TAX_RATE
    end

    calculate(:county_single_item_tax) do
      [SINGLE_ITEM_CEILING, dealer_sales_price].min * county_upfront_tax_rate
    end

    # Inherited From UpfrontTaxCalculator
    # calculate(:state_upfront_tax_rate)  { state_upfront_tax_percentage / 100.0 }
    # calculate(:county_upfront_tax_rate) { county_upfront_tax_percentage / 100.0 }
    # calculate(:cash_down_payment_or_zero) { [Money.zero, cash_down_payment].max }
  end
end