module Calculators
  class UpfrontTaxCalculator < LdstudiosRubyCalculator::Base

    SOUTH_CAROLINA_LIMIT = 10_000.to_money.freeze
    FLORIDA_COUNTY_LIMIT = 5000.to_money.freeze
    OKLAHOMA_MINIMUM_TAX = 20.to_money.freeze
    OKLAHOMA_MINIMUM_CEILING = 1500.to_money.freeze

    attr_accessor :state_upfront_tax_percentage,
                  :county_upfront_tax_percentage,
                  :local_upfront_tax_percentage,
                  :gross_trade_in_allowance,
                  :cash_down_payment,
                  :lessee_state,
                  :dealer_sales_price,
                  :ga_tavt_value,
                  :dealer_freight_and_setup,
                  :title_license_and_lien_fee,
                  :dealer_documentation_fee,
                  :guaranteed_auto_protection_cost,
                  :prepaid_maintenance_cost,
                  :extended_service_contract_cost,
                  :tire_and_wheel_contract_cost,
                  :gps_cost,
                  :sales_tax_rate

    #The Upfront Tax (really **any** tax) can never be negative.
    calculate(:upfront_tax) { 
      [Money.zero, (state_upfront_tax + county_upfront_tax + local_upfront_tax)].max
    }

    #Big Case Statement that chooses the right algorithm
    #based on the Lessee State (where the Bike is Registered)
    calculate(:state_upfront_tax) do
      raise 'Lessee State not provided' if lessee_state.blank?
      case symbolized_lessee_state
      when :florida, :north_carolina, :arizona, :indiana, :mississippi, :new_mexico, :pennsylvania, :nevada
        cash_down_payment_or_zero * state_upfront_tax_rate
      when :south_carolina
        [(dealer_sales_price + dealer_freight_and_setup + dealer_documentation_fee - gross_trade_in_allowance + gps_cost), SOUTH_CAROLINA_LIMIT].min * state_upfront_tax_rate
      when :maryland
        (dealer_sales_price + dealer_freight_and_setup + dealer_documentation_fee - gross_trade_in_allowance + gps_cost) * state_upfront_tax_rate
      when :texas
        (dealer_sales_price + dealer_freight_and_setup - gross_trade_in_allowance + gps_cost) * state_upfront_tax_rate
      when :georgia
        (ga_tavt_value - gross_trade_in_allowance)
      when :virginia, :michigan
        #upfront based on the sum of the bike sale price, freight/prep, and dealer doc fee. There is no credit for the trade-in.
        (dealer_sales_price + dealer_freight_and_setup + dealer_documentation_fee + gps_cost) * state_upfront_tax_rate
      when :oklahoma
        # Used Vehicle: $20.00 on the 1st $1500.00 of value + 3.25% of the remainder
        # Both of the above rates are plus 1.25% State Sales tax for total rates of 4.5%. 
        # Purchase Price above = Calculator Bike Sale Price + Freight / Prep Fee
        # No credit for trade. No local jurisdictions.
        OKLAHOMA_MINIMUM_TAX + [(dealer_sales_price + dealer_freight_and_setup + gps_cost - OKLAHOMA_MINIMUM_CEILING), Money.zero].max * state_upfront_tax_rate
      when :california, :louisiana
        (gross_trade_in_allowance + cash_down_payment_or_zero + gps_cost) * combined_upfront_tax_rate
      when :missouri #combined to prevent a penny error from happening
        (dealer_sales_price + dealer_freight_and_setup - gross_trade_in_allowance + gps_cost) * combined_upfront_tax_rate
      when :tennessee
        raise RuntimeError('Please calculate the TN Upfront Tax using the specific TennesseeUpfrontTax Calculator')
      when :delaware
        #( ( (dealer_sales_price + gross_trade_in_allowance + gps_cost) * state_upfront_tax_rate) + (cash_down_payment_or_zero * sales_tax_rate) ).to_f.ceil.to_money
        #( (dealer_sales_price * state_upfront_tax_rate) + (cash_down_payment_or_zero * sales_tax_rate) ).to_money      

        #(dealer_sales_price * state_upfront_tax_rate).to_f.ceil.to_money 
        (dealer_sales_price * state_upfront_tax_rate).to_f.ceil.to_money + (cash_down_payment_or_zero * sales_tax_rate).to_money
        
      when :new_jersey
        # (Bike Sale Price + Freight / Prep Fee + Documentation Fee + GAP + Prepaid Maintenance + Extended Service Contract + Tire & Wheel - Gross Trade In Allowance) * state_upfront_tax_rate
        (dealer_sales_price + dealer_freight_and_setup + dealer_documentation_fee + guaranteed_auto_protection_cost + prepaid_maintenance_cost + extended_service_contract_cost + tire_and_wheel_contract_cost - gross_trade_in_allowance + gps_cost) * state_upfront_tax_rate
      else
        Money.zero
      end
    end

    calculate(:county_upfront_tax) do
      case symbolized_lessee_state
      when :florida
        [cash_down_payment_or_zero, FLORIDA_COUNTY_LIMIT].min * county_upfront_tax_rate
      when :arizona, :new_mexico, :pennsylvania, :nevada
        cash_down_payment_or_zero * county_upfront_tax_rate
      else
        Money.zero
      end
    end

    calculate(:local_upfront_tax) do
      case symbolized_lessee_state
      when :arizona, :new_mexico, :pennsylvania, :nevada
        cash_down_payment_or_zero * local_upfront_tax_rate
      else
        Money.zero
      end
    end

    calculate(:state_upfront_tax_rate)  { state_upfront_tax_percentage / 100.0 }
    calculate(:county_upfront_tax_rate) { county_upfront_tax_percentage / 100.0 }
    calculate(:local_upfront_tax_rate) { local_upfront_tax_percentage / 100.0 }
    calculate(:combined_upfront_tax_rate) { state_upfront_tax_rate + county_upfront_tax_rate + local_upfront_tax_rate }
    calculate(:cash_down_payment_or_zero) { [Money.zero, cash_down_payment].max }

    def symbolized_lessee_state
      @symbolized_lessee_state ||= lessee_state.parameterize(separator: '_').to_sym
    end
  end
end
