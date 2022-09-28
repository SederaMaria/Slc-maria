class LeaseRecalculator
  attr_accessor :input_values, :lease_calculator, :return_values

  DEFAULT_TERM = 24

  def initialize(input_values: {}, lease_calculator: nil)
    @input_values     = input_values
    @return_values    = {}
    @lease_calculator = lease_calculator.nil? ? LeaseCalculator.new(input_values) : lease_calculator
  end

  def recalculate_and_save
    lease_calculator.update(recalculate)
  end

  def recalculate
    setting = settings
    # security_deposit = setting.try(:enable_global_security_deposit) ? Money.new(setting.global_security_deposit * 100).to_s :
    #                        calculator.refundable_security_deposit.to_s
   security_deposit = is_enable_security_deposit ? Money.new(get_security_deposit * 100).to_s :
                          calculator.refundable_security_deposit.to_s
    ### Returned & Formatted Inputs
    return_values['dealer_sales_price']              = calculator.dealer_sales_price.to_s
    return_values['dealer_freight_and_setup']        = calculator.dealer_freight_and_setup.to_s
    return_values['dealer_documentation_fee']        = calculator.dealer_documentation_fee.to_s
    return_values['title_license_and_lien_fee']      = calculator.title_license_and_lien_fee.to_s
    return_values['guaranteed_auto_protection_cost'] = calculator.guaranteed_auto_protection_cost.to_s
    return_values['tire_and_wheel_contract_cost']    = calculator.tire_and_wheel_contract_cost.to_s
    return_values['gps_cost']                        = calculator.gps_cost.to_s
    return_values['prepaid_maintenance_cost']        = calculator.prepaid_maintenance_cost.to_s
    return_values['extended_service_contract_cost']  = calculator.extended_service_contract_cost.to_s
    return_values['gross_trade_in_allowance']        = calculator.gross_trade_in_allowance.to_s
    return_values['trade_in_payoff']                 = calculator.trade_in_payoff.to_s
    return_values['cash_down_payment']               = calculator.cash_down_payment.to_s

    ### Calculations
    return_values['nada_retail_value']           = calculator.nada_retail_value.to_s
    return_values['nada_rough_value']            = calculator.nada_rough_value.to_s
    return_values['customer_purchase_option']    = calculator.customer_purchase_option.to_s
    return_values['total_dealer_price']          = calculator.total_dealer_price.to_s
    return_values['upfront_tax']                 = calculator.upfront_tax.to_s
    return_values['ga_tavt_value']               = calculator.ga_tavt_value.to_s
    return_values['total_sales_price']           = calculator.total_sales_price.to_s
    return_values['adjusted_capitalized_cost']   = calculator.adjusted_capitalized_cost.to_s
    return_values['remit_to_dealer']             = calculator.remit_to_dealer.to_s
    if @input_values['us_state'] == 'georgia'
      return_values['upfront_tax']               = calculator.ga_tavt_value.to_s
      return_values['total_sales_price']         = ((calculator.total_sales_price - calculator.upfront_tax) + calculator.ga_tavt_value).to_s
      return_values['adjusted_capitalized_cost'] = ((calculator.adjusted_capitalized_cost - calculator.upfront_tax) + calculator.ga_tavt_value).to_s
      return_values['remit_to_dealer']           = ((calculator.remit_to_dealer - calculator.upfront_tax) + calculator.ga_tavt_value).to_s
    end
    return_values['fi_maximum_total']            = calculator.fi_maximum_total.to_s
    return_values['gross_trade_in_allowance']    = calculator.gross_trade_in_allowance.to_s
    return_values['trade_in_payoff']             = calculator.trade_in_payoff.to_s
    return_values['net_trade_in_allowance']      = calculator.net_trade_in_allowance.to_s    
    return_values['monthly_lease_charge']        = calculator.monthly_lease_charge.to_s
    return_values['monthly_depreciation_charge'] = calculator.monthly_depreciation_charge.to_s
    return_values['base_monthly_payment']        = calculator.base_monthly_payment.to_s
    return_values['monthly_sales_tax']           = calculator.monthly_sales_tax.to_s
    return_values['total_monthly_payment']       = calculator.total_monthly_payment.to_s
    return_values['acquisition_fee']             = calculator.acquisition_fee.to_s
    return_values['total_cash_at_signing']       = calculator.total_cash_at_signing.to_s
    return_values['refundable_security_deposit'] = security_deposit
    return_values['dealer_reserve']              = calculator.dealer_reserve.to_s
    return_values['servicing_fee']               = calculator.servicing_fee.to_s
    return_values['backend_max_advance']         = calculator.maximum_backend_advance.to_s
    return_values['frontend_max_advance']        = calculator.maximum_frontend_advance.to_s
    return_values['cash_down_minimum']           = calculator.cash_down_minimum.to_s
    return_values['backend_total']               = calculator.backend_total.to_s
    return_values['frontend_total']              = calculator.frontend_total.to_s
    return_values['cash_down_minimum']           = calculator.cash_down_minimum.to_s
    return_values['pre_tax_payments_sum']        = calculator.pre_tax_payments_sum.to_s
    return_values['acc_less_fi_less_af']         = calculator.acc_less_fi_less_af.to_s
    return_values['gross_capitalized_cost']      = calculator.gross_capitalized_cost.to_s

    ### Stored Values
    return_values['original_msrp']               = model_year_record.present? ? model_year_record.original_msrp.to_s : '0.00'
    
    CustomLogger.log_info("#{self.class.to_s}#recalculate", "MINIMUM CASH, UPFRONT TAX AND, AND PRIMARY LEASE CALCULATOR HAVE **FINISHED RECALCULATING** #{Time.now}")
    return_values
  end

  # TODO - FIX ME.  
  # the calculator substracts the ratio (perc divided by 100) from the F&I Max Advance rate (from the credit tier) 
  # so it goes like this.  46 X 46 X 46 = 46 cubed = 97,336%.  Thats obviously wrong.
  # .46 X .46 X .46 = .097 = 9.7%.  That should be the equivalent of 46% of 46% of 46%.  I think thats correct.  

  # def maximum_frontend_advance_haircut
  #   return 1 if mileage_tier_record.nil? || model_group_record.nil? || model_year_record.nil?
  #   @maximum_frontend_advance_haircut ||=
  #     mileage_tier_record&.read_attribute(:"maximum_frontend_advance_haircut_#{asset_age}")&.*(
  #       model_group_record&.read_attribute(:"maximum_haircut_#{asset_age}")&.*(
  #         model_year_record&.read_attribute(:"maximum_haircut_#{asset_age}")
  #       ))
  # end

  def maximum_frontend_advance_haircut
    @maximum_frontend_advance_haircut ||= mileage_tier_record&.read_attribute(:"maximum_frontend_advance_haircut_#{asset_age}")
  end

  def errors_for_json_response
    errors = []

    if calculator.backend_total > calculator.maximum_backend_advance
      errors << "<li data-id='backend_total_error'>Backend total must not exceed Backend Maximum</li>"
    end

    if calculator.cash_down_payment < calculator.cash_down_minimum
      errors << "<li data-id='cash_down_payment_error'>Down Payment must meet or exceed Minimum Required</li>"
    end

    if payment_limit = calculator_record&.lease_application&.lease_application_payment_limits&.last
      # Anything not more than $0 will not be regarded as an error
      if payment_limit.override_max_allowable_payment ? payment_limit.override_max_allowable_payment&.positive? : payment_limit.max_allowable_payment&.positive?
        # Total Monthly Payment > Max Allowable Payment
        if calculator.total_monthly_payment > (payment_limit.override_max_allowable_payment || payment_limit.max_allowable_payment)
          errors << "<li data-id='total_monthly_payment_error'>Monthly Total Payment must not exceed Payment Limit (Max Allowable Payment)</li>"
        end
      end
    end

    errors.join
  end

  private
  
  def calculator
    @calculator ||= Calculators::LeaseCalculator.new(calculator_inputs)
  end

  def calculator_inputs
    {
      nada_retail_value:                       model_year_record&.nada_avg_retail || Money.zero,
      nada_rough_value:                        model_year_record&.nada_rough || Money.zero,
      customer_purchase_option:                calculate_customer_purchase_option || Money.zero,
      dealer_sales_price:                      dealer_sales_price || Money.zero,
      ga_tavt_value:                           ga_tavt_value || Money.zero,
      dealer_freight_and_setup:                dealer_freight_and_setup || Money.zero,
      title_license_and_lien_fee:              title_license_and_lien_fee || Money.zero,
      dealer_documentation_fee:                dealer_documentation_fee || Money.zero,
      guaranteed_auto_protection_cost:         guaranteed_auto_protection_cost || Money.zero,
      prepaid_maintenance_cost:                prepaid_maintenance_cost || Money.zero,
      extended_service_contract_cost:          extended_service_contract_cost || Money.zero,
      tire_and_wheel_contract_cost:            tire_and_wheel_contract_cost || Money.zero,
      gps_cost:                                gps_cost || Money.zero,
      gross_trade_in_allowance:                gross_trade_in_allowance || Money.zero,
      trade_in_payoff:                         trade_in_payoff || Money.zero,
      dealer_participation_markup:             dealer_participation_markup || BigDecimal.new(0.0),
      rebates_and_noncash_credits:             rebates_and_noncash_credits || Money.zero,
      cash_down_payment:                       cash_down_payment || Money.zero,
      # acquisition_fee:                         credit_tier_record&.acquisition_fee || 0,
      term:                                    term || DEFAULT_TERM,
      maximum_fi_advance_percentage:           credit_tier_record&.maximum_advance_percentage || 0,
      max_frontend_advance_haircut:            maximum_frontend_advance_haircut || 0,
      state_upfront_tax_percentage:            tax_jurisdiction_record&.state_upfront_tax_percentage || 0,
      county_upfront_tax_percentage:           tax_jurisdiction_record&.county_upfront_tax_percentage || 0,
      local_upfront_tax_percentage:            tax_jurisdiction_record&.local_upfront_tax_percentage || 0,
      sales_tax_percentage:                    tax_jurisdiction_record&.total_sales_tax_percentage || 0,
      annual_yield:                            (credit_tier_record&.irr_value || 0),
      dealer_participation_sharing_percentage: dealer_participation_sharing_percentage,
      base_servicing_fee:                      settings.try(:base_servicing_fee) || "",
      lessee_state:                            us_state,
      minimum_dealer_participation:            minimum_dealer_participation,
      maximum_backend_percentage:              credit_tier_record&.maximum_fi_advance_percentage || 100,
      backend_advance_minimum:                 model_group_record&.backend_advance_minimum || Money.zero,
      security_deposit:                        get_security_deposit,
      enable_security_deposit:                 is_enable_security_deposit,
      credit_tier_id:                          credit_tier_record&.id || nil,
      deal_fee:                                get_dealership&.deal_fee || Money.zero,
      calculation_name:                        get_dealership&.remit_to_dealer_calculation&.calculation_name
    }
  end

  def settings
    @settings ||= if get_make.present?
      ApplicationSetting.find_by(make_id: get_make.id)
    else
      ApplicationSetting.first
    end
  end
  
  def common_application_settings
    CommonApplicationSetting.first
  end

  def dealer_participation_sharing_percentage
    return 0 if common_application_settings.deactivate_dealer_participation
    (term.present? && settings.present? ? settings.read_attribute(:"dealer_participation_sharing_percentage_#{term}") : 0) 
  end

  def minimum_dealer_participation
    (common_application_settings.deactivate_dealer_participation ? Money.zero : model_year_record&.minimum_dealer_participation) || Money.zero
  end


  def get_security_deposit
    GlobalSecurityDeposit.value(settings, get_us_state, credit_tier_record, get_dealership)
  end
  
  def is_enable_security_deposit
    GlobalSecurityDeposit.enable_security_deposit(settings, get_us_state, credit_tier_record, get_dealership)
  end

  def calculator_record
    id = lease_calculator&.id.nil? ? @input_values['id'].to_i : lease_calculator&.id
    LeaseCalculator.find(id)
  end

  def get_dealership
    return nil if calculator_record.nil?
    return nil if calculator_record&.lease_application.nil?
    calculator_record&.lease_application&.dealership
  end
  
  def get_us_state
    UsState.find_by(name: us_state.upcase.gsub('_',' '))
  end

  def get_make
    Make.find_by(name: lease_calculator.asset_make) || Make.find_by(id: lease_calculator.asset_make)
  end

  def tax_jurisdiction_record
    @tax_jurisdiction_record ||= TaxJurisdiction.where(us_state: us_state, name: tax_jurisdiction).first
  end


  def credit_tier_record
    # @credit_tier_record ||= CreditTier.for_make_name(settings&.make&.name).where(description: (credit_tier.nil? ? calculator_record.credit_tier : credit_tier ) ).first
    if credit_tier_id.nil?
      @credit_tier_record ||= calculator_record&.credit_tier_record
    else
      @credit_tier_record ||= CreditTier.find(credit_tier_id)
    end
  end

  def model_year_record
    @model_year_record ||= ModelYear.active.for_make_model_and_year(settings&.make&.name, asset_model, asset_year).first
  end

  def model_group_record
    @model_group_record ||= model_year_record&.model_group
  end

  def mileage_tier_record
    return nil if mileage_tier.blank?
    lower, upper         = mileage_tier.split(' - ').map{ |mil| mil.delete(',').to_i }
    upper = 999999 if upper.nil? && (lower == 90000)
    @mileage_tier_record ||= MileageTier.where(lower: lower, upper: upper).first
  end

  def asset_age
    @asset_age ||= Date.current.year if settings.present?
  end

  def calculate_customer_purchase_option
    model_year_record && term ? model_year_record.send("residual_#{term}") : Money.zero
  end

  def method_missing(method, *args)
    if lease_calculator.respond_to? method
      lease_calculator.send(method, *args)
    else
      super
    end
  end
end