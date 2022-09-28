module Calculators
  class LeaseCalculator < LdstudiosRubyCalculator::Base

    attr_accessor :nada_retail_value, :nada_rough_value, :customer_purchase_option, :dealer_sales_price, :dealer_freight_and_setup,
                  :title_license_and_lien_fee, :dealer_documentation_fee, :guaranteed_auto_protection_cost,
                  :prepaid_maintenance_cost, :extended_service_contract_cost, :tire_and_wheel_contract_cost,
                  :gross_trade_in_allowance, :trade_in_payoff, :dealer_participation_markup,
                  :rebates_and_noncash_credits, :cash_down_payment, :acquisition_fee, :term,
                  :maximum_fi_advance_percentage, :annual_yield, :sales_tax_percentage,
                  :dealer_participation_sharing_percentage, :base_servicing_fee,
                  :lessee_state, :maximum_backend_percentage, :minimum_dealer_participation,
                  :max_frontend_advance_haircut, :ga_tavt_value, :backend_advance_minimum, 
                  :security_deposit, :enable_security_deposit, :credit_tier_id, :acc_less_fi_less_af, 
                  :deal_fee, :calculation_name, :gps_cost

    #upfront tax inputs
    attr_accessor :state_upfront_tax_percentage, :county_upfront_tax_percentage, :local_upfront_tax_percentage


    calculate(:upfront_tax_temp) do
      case parameterized_lessee_state
      when :ohio
        ohio_upfront_tax_calculator_zero_acq.try(:upfront_tax)
      when :illinois
        illinois_upfront_tax_calculator_zero_acq.try(:upfront_tax)
      else
        upfront_tax
      end
    end

    calculate(:acquisition_fee_temp) do
      acq_fee_calc = dealer_sales_price + dealer_freight_and_setup + dealer_documentation_fee + title_license_and_lien_fee + upfront_tax_temp - net_trade_in_allowance - cash_down_payment
      acq_fee_cent = acq_fee_calc * 100
      acq_fee = credit_tier_id.nil? ? 0 : (AdjustedCapitalizedCostRange.where(credit_tier_id: credit_tier_id).where("? >= adjusted_cap_cost_lower_limit AND ? <= adjusted_cap_cost_upper_limit", acq_fee_cent.to_f, acq_fee_cent.to_f).order(adjusted_cap_cost_lower_limit: :asc).first&.acquisition_fee.to_f)
      if acq_fee == 0
        acq_fee = credit_tier_id.nil? ? 0 : AdjustedCapitalizedCostRange.where(credit_tier_id: credit_tier_id).where("? >= adjusted_cap_cost_lower_limit AND ? = adjusted_cap_cost_upper_limit", acq_fee_cent.to_f, 0).order(adjusted_cap_cost_lower_limit: :asc).first&.acquisition_fee.to_f
      end
      acq_fee
    end

    calculate(:upfront_tax_temp_2) do
      case parameterized_lessee_state
      when :ohio
        ohio_upfront_tax_calculator_temp_acq.try(:upfront_tax)
      when :illinois
        illinois_upfront_tax_calculator_temp_acq.try(:upfront_tax)
      else
        upfront_tax
      end
    end

    calculate(:upfront_tax_less_cash_down) do
      upfront_tax_calculator_less_cash_down.try(:upfront_tax)      
    end
   
    calculate(:acc_less_fi_less_af) do
      acq_fee_calc = dealer_sales_price + dealer_freight_and_setup + dealer_documentation_fee + title_license_and_lien_fee + gps_cost + upfront_tax_temp_2 - net_trade_in_allowance - cash_down_payment
      acq_fee_calc * 100
    end


    #TODO add validations all financial inputs are Money classes

    calculate(:acquisition_fee) do
      acq_fee = credit_tier_id.nil? ? 0 : (AdjustedCapitalizedCostRange.where(credit_tier_id: credit_tier_id).where("? >= adjusted_cap_cost_lower_limit AND ? <= adjusted_cap_cost_upper_limit", acc_less_fi_less_af.to_f, acc_less_fi_less_af.to_f).order(adjusted_cap_cost_lower_limit: :asc).first&.acquisition_fee.to_f)
      if acq_fee == 0
        acq_fee = credit_tier_id.nil? ? 0 : AdjustedCapitalizedCostRange.where(credit_tier_id: credit_tier_id).where("? >= adjusted_cap_cost_lower_limit AND ? = adjusted_cap_cost_upper_limit", acc_less_fi_less_af.to_f, 0).order(adjusted_cap_cost_lower_limit: :asc).first&.acquisition_fee.to_f
      end
      acq_fee
    end

    calculate(:total_dealer_price) { dealer_sales_price + dealer_freight_and_setup }
    calculate(:upfront_tax) { upfront_tax_calculator.try(:upfront_tax) }
    calculate(:net_trade_in_allowance) { gross_trade_in_allowance - trade_in_payoff }

    #Back End (F&I) = GAP + PPM + ESC + T&W
    calculate(:backend_total) do
      guaranteed_auto_protection_cost +
      prepaid_maintenance_cost +
      extended_service_contract_cost +
      tire_and_wheel_contract_cost +
      gps_cost
    end

    #Front End = Sale Price + Freight + Upfront Tax + Title + Doc  
    calculate(:frontend_total) do
      total_dealer_price + upfront_tax + title_license_and_lien_fee +
      dealer_documentation_fee
    end

    calculate(:total_sales_price) { frontend_total + backend_total }

    calculate(:maximum_backend_advance) do
      [(maximum_backend_percentage / 100.0) * nada_retail_value, backend_advance_minimum].max
    end

    calculate(:maximum_frontend_advance) do
      (maximum_fi_advance_rate - max_frontend_advance_haircut_rate) * nada_retail_value
    end

    calculate(:frontend_advance) do
      [maximum_frontend_advance,frontend_total].min
    end

    # Adjusted Cap Cost   
    calculate(:adjusted_capitalized_cost) do
      (gross_capitalized_cost.to_f - cash_down_payment.to_f - net_trade_in_allowance.to_f).to_money  
    end

    #Gross Cap Cost = Front End + Back End + Acquisition Fee
    calculate(:gross_capitalized_cost) do
    (frontend_total.to_f + backend_total.to_f + acquisition_fee.to_f).to_money
    end

    calculate(:pre_tax_payments_sum) do
      if upfront_tax_calculator.respond_to?(:pre_tax_payments_sum)
        upfront_tax_calculator.pre_tax_payments_sum
      else
        base_monthly_payment * term
      end
    end

    #(Adjusted Cap Cost – Residual) / Term)
    calculate(:monthly_lease_charge) do
      precise_result = ((adjusted_capitalized_cost.to_f - customer_purchase_option.to_f) / term).to_money
    end

    #((Adjusted Cap Cost + Residual) * APR / 24)
    calculate(:monthly_depreciation_charge) do
      precise_result = ((adjusted_capitalized_cost.to_f + customer_purchase_option.to_f) * money_factor).to_money 
    end

    calculate(:base_monthly_payment) do
      # monthly_lease_charge + monthly_depreciation_charge
      FinanceMath::Loan.new(nominal_rate: annual_yield, duration: term, amount: adjusted_capitalized_cost.to_f).pmt(future_value: customer_purchase_option.to_f, type: 1).to_money
    end

    calculate(:monthly_sales_tax) do
      precise =  (base_monthly_payment.exchange_to(:us8) * sales_tax_rate) 
      precise.exchange_to(:usd) 
    end
    
    calculate(:total_monthly_payment) { monthly_sales_tax + base_monthly_payment }

    calculate(:fi_maximum_total) do
      [1_000.to_money, (nada_retail_value * maximum_fi_advance_rate)].max
    end

    calculate(:total_cash_at_signing) do
      (cash_down_payment.to_f + total_monthly_payment.to_f + servicing_fee.to_f + refundable_security_deposit.to_f).to_money
    end

    calculate(:refundable_security_deposit) do
      enable_security_deposit ? Money.new(security_deposit * 100) : Money.zero
    end

    calculate(:remit_to_dealer) do
      remit = remit_to_dealer_slc_standard_lease
      remit = remit_to_dealer_slc_partner_lease if calculation_name == 'SLC Partner Lease'
      remit
    end

    calculate(:remit_to_dealer_slc_standard_lease) do
      (total_sales_price.to_f + dealer_reserve.to_f - total_cash_at_signing.to_f - net_trade_in_allowance.to_f).to_money
    end

    calculate(:remit_to_dealer_slc_partner_lease) do
      (deal_fee + dealer_documentation_fee + upfront_tax + title_license_and_lien_fee + guaranteed_auto_protection_cost + prepaid_maintenance_cost + extended_service_contract_cost + tire_and_wheel_contract_cost + gps_cost).to_money
    end

    calculate(:dealer_reserve) do
      ([minimum_dealer_participation.to_f, calculated_dealer_reserve_value.to_f].max).to_money
    end

    calculate(:calculated_dealer_reserve_value) do
      rate_factor(combined_monthly_yield).zero? && combined_monthly_yield.zero? ?
        Money.zero :
        ((rate_factor(combined_monthly_yield) / combined_monthly_yield) *
        gross_capitalized_cost *
        dealer_participation_sharing_rate *
        dealer_participation_markup_rate)
    end

    calculate(:servicing_fee) { base_servicing_fee * term }

    calculate(:cash_down_minimum_estimate) do
      (maximum_frontend_advance - dealer_sales_price - dealer_freight_and_setup -
      dealer_documentation_fee - title_license_and_lien_fee - upfront_tax +
      net_trade_in_allowance) * -1
    end

    calculate(:cash_down_minimum) do
      cash_down_minimum_calculator.cash_down_minimum
    end

    ########################################
    ### YIELD, APR, AND RATE CONVERSIONS ###
    ########################################

    calculate(:dealer_participation_sharing_rate) { dealer_participation_sharing_percentage / 100.0 }

    calculate(:maximum_fi_advance_rate) { maximum_fi_advance_percentage / 100.0 }

    #Hasham's Yield
    calculate(:monthly_yield) { annual_to_monthly_yield(annual_yield) }

    #Brian's Yield
    calculate(:money_factor) { (annual_yield + dealer_participation_markup) / 2400.0}

    calculate(:compromise_yield) { (monthly_yield + money_factor) / 2.0 }

    calculate(:dealer_participation_markup_rate) { annual_to_monthly_yield(dealer_participation_markup) }

    calculate(:dealer_participation_sharing_rate) { dealer_participation_sharing_percentage / 100.0 }

    calculate(:sales_tax_rate) { sales_tax_percentage / 100.0 }

    calculate(:max_frontend_advance_haircut_rate) { max_frontend_advance_haircut / 100.0 }

    calculate(:combined_monthly_yield) { monthly_yield + dealer_participation_markup_rate }

    def upfront_tax_calculator
      case parameterized_lessee_state
      when :tennessee
        tennessee_upfront_tax_calculator
      when :ohio
        ohio_upfront_tax_calculator
      when :alabama
        alabama_upfront_tax_calculator
      when :illinois
        illinois_upfront_tax_calculator
      else
        default_upfront_tax_calculator
      end
    end

    private

    def parameterized_lessee_state
      @parameterized_lessee_state ||= lessee_state.parameterize(separator: '_').to_sym
    end

    def annual_to_monthly_yield(_annual_yield)
      _annual_yield.zero? ? 0.0 : ((_annual_yield/100.0 + 1)**(1.0/12.0))-1 #=((F9+1)^(1.0/12.0))-1
    end

    def rate_factor(factor)
      1.0-(1.0+factor)**-term
    end

    def default_upfront_tax_calculator
        @default_upfront_tax_calculator ||= Calculators::UpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        local_upfront_tax_percentage: local_upfront_tax_percentage,
        gross_trade_in_allowance: gross_trade_in_allowance,
        cash_down_payment: cash_down_payment,
        lessee_state: lessee_state,
        dealer_sales_price: dealer_sales_price,
        ga_tavt_value: ga_tavt_value,
        dealer_freight_and_setup: dealer_freight_and_setup,
        title_license_and_lien_fee: title_license_and_lien_fee,
        dealer_documentation_fee: dealer_documentation_fee,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost,
        sales_tax_rate: sales_tax_rate
      })
    end

    def upfront_tax_calculator_less_cash_down
        @upfront_tax_calculator_less_cash_down ||= Calculators::UpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        local_upfront_tax_percentage: local_upfront_tax_percentage,
        gross_trade_in_allowance: gross_trade_in_allowance,
        cash_down_payment: 0,
        lessee_state: lessee_state,
        dealer_sales_price: dealer_sales_price,
        ga_tavt_value: ga_tavt_value,
        dealer_freight_and_setup: dealer_freight_and_setup,
        title_license_and_lien_fee: title_license_and_lien_fee,
        dealer_documentation_fee: dealer_documentation_fee,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost
      })      
    end

    def tennessee_upfront_tax_calculator
      @upfront_tax_calculator ||= Calculators::TennesseeUpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        cash_down_payment: cash_down_payment,
        dealer_sales_price: dealer_sales_price,
      })
    end

  def alabama_upfront_tax_calculator
    @upfront_tax_calculator ||= Calculators::AlabamaUpfrontTaxCalculator.new({
      state_upfront_tax_percentage: state_upfront_tax_percentage,
      county_upfront_tax_percentage: county_upfront_tax_percentage,
      local_upfront_tax_percentage: local_upfront_tax_percentage,
      cash_down_payment: cash_down_payment,
      gross_trade_in_allowance: gross_trade_in_allowance
    })
  end

    def ohio_upfront_tax_calculator
      @upfront_tax_calculator ||= Calculators::OhioUpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        cash_down_payment: cash_down_payment,
        gross_trade_in_allowance: gross_trade_in_allowance,
        trade_in_payoff: trade_in_payoff,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost,
        dealer_sales_price: dealer_sales_price,
        title_license_and_lien_fee: title_license_and_lien_fee,
        dealer_documentation_fee: dealer_documentation_fee,
        acquisition_fee: acquisition_fee.to_money,
        dealer_freight_and_setup: dealer_freight_and_setup,
        customer_purchase_option: customer_purchase_option,
        money_factor: money_factor,
        term: term,
      })
    end

    def ohio_upfront_tax_calculator_zero_acq
      Calculators::OhioUpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        cash_down_payment: cash_down_payment,
        gross_trade_in_allowance: gross_trade_in_allowance,
        trade_in_payoff: trade_in_payoff,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost,
        dealer_sales_price: dealer_sales_price,
        title_license_and_lien_fee: title_license_and_lien_fee,
        dealer_documentation_fee: dealer_documentation_fee,
        acquisition_fee: 0,
        dealer_freight_and_setup: dealer_freight_and_setup,
        customer_purchase_option: customer_purchase_option,
        money_factor: money_factor,
        term: term,
      })
    end

    def ohio_upfront_tax_calculator_temp_acq
      Calculators::OhioUpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        cash_down_payment: cash_down_payment,
        gross_trade_in_allowance: gross_trade_in_allowance,
        trade_in_payoff: trade_in_payoff,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost,
        dealer_sales_price: dealer_sales_price,
        title_license_and_lien_fee: title_license_and_lien_fee,
        dealer_documentation_fee: dealer_documentation_fee,
        acquisition_fee: acquisition_fee_temp.to_money,
        dealer_freight_and_setup: dealer_freight_and_setup,
        customer_purchase_option: customer_purchase_option,
        money_factor: money_factor,
        term: term,
      })
    end

    def illinois_upfront_tax_calculator
      @upfront_tax_calculator ||= Calculators::IllinoisUpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        local_upfront_tax_percentage: local_upfront_tax_percentage,
        cash_down_payment: cash_down_payment,
        gross_trade_in_allowance: gross_trade_in_allowance,
        trade_in_payoff: trade_in_payoff,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost,
        dealer_sales_price: dealer_sales_price,
        dealer_documentation_fee: dealer_documentation_fee,
        acquisition_fee: acquisition_fee.to_money,
        dealer_freight_and_setup: dealer_freight_and_setup,
        customer_purchase_option: customer_purchase_option,
        money_factor: money_factor,
        term: term,
      })
    end

    def illinois_upfront_tax_calculator_zero_acq
      Calculators::IllinoisUpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        local_upfront_tax_percentage: local_upfront_tax_percentage,
        cash_down_payment: cash_down_payment,
        gross_trade_in_allowance: gross_trade_in_allowance,
        trade_in_payoff: trade_in_payoff,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost,
        dealer_sales_price: dealer_sales_price,
        dealer_documentation_fee: dealer_documentation_fee,
        acquisition_fee: 0,
        dealer_freight_and_setup: dealer_freight_and_setup,
        customer_purchase_option: customer_purchase_option,
        money_factor: money_factor,
        term: term,
      })
    end

    def illinois_upfront_tax_calculator_temp_acq
      Calculators::IllinoisUpfrontTaxCalculator.new({
        state_upfront_tax_percentage: state_upfront_tax_percentage,
        county_upfront_tax_percentage: county_upfront_tax_percentage,
        local_upfront_tax_percentage: local_upfront_tax_percentage,
        cash_down_payment: cash_down_payment,
        gross_trade_in_allowance: gross_trade_in_allowance,
        trade_in_payoff: trade_in_payoff,
        guaranteed_auto_protection_cost: guaranteed_auto_protection_cost,
        prepaid_maintenance_cost: prepaid_maintenance_cost,
        extended_service_contract_cost: extended_service_contract_cost,
        tire_and_wheel_contract_cost: tire_and_wheel_contract_cost,
        gps_cost: gps_cost,
        dealer_sales_price: dealer_sales_price,
        dealer_documentation_fee: dealer_documentation_fee,
        acquisition_fee: acquisition_fee_temp.to_money,
        dealer_freight_and_setup: dealer_freight_and_setup,
        customer_purchase_option: customer_purchase_option,
        money_factor: money_factor,
        term: term,
      })
    end


    def cash_down_minimum_calculator
      CashDownMinimumCalculator.new({
        estimate: cash_down_minimum_estimate,
        lease_calculator: self,
      })
    end
  end
end