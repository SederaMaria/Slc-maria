require 'nokogiri'

class GenerateXmlService

  def initialize(lease_application:)
    @lease_application = lease_application
  end

    def generate_manufacturer_search_xml
        xml = Builder::XmlMarkup.new
        return "" unless @lease_application.present?
        xml.LPSEARCH do |d|
            d.searchType("MNF")
            d.searchLike(@lease_application&.last_lease_document_request&.asset_make)
        end    
    end

    def generate_vendor_load_xml(dealership_id)
        @dealership = Dealership.find(dealership_id)
        xml = Builder::XmlMarkup.new
        return "" unless @dealership.present?
        client_number = @dealership.access_id.present? ? @dealership.access_id  : @dealership.id        
        xml.VENDOR_INFO do |msi|
            msi.VENDOR_RECORD do |d|
                d.localAddOnly(false)
                d.portfolio("1")
                d.company("1")
                d.region("1")
                d.office("1")
                d.clientNumber("D#{client_number}")
                d.name(@dealership.name)
                d.address1(@dealership&.address&.street1)
                d.address2(@dealership&.address&.street2)
                d.city(@dealership&.address&.city)
                d.state(@dealership&.address&.state)
                d.zipCode(@dealership&.address&.zipcode)
                d.busPhone(@dealership&.primary_contact_phone&.gsub(/[^0-9]/, ''))
                d.shortname(@dealership.name)
            end 
       end  
    end

    def generate_asset_model_search_xml(manufacturer_code)
        xml = Builder::XmlMarkup.new
        return "" unless @lease_application.present?
        xml.LPSEARCH do |d|
            d.searchType("MDL")
            d.searchLike("#{@lease_application&.last_lease_document_request&.asset_model} - #{@lease_application&.last_lease_document_request&.asset_year}")
            d.parameter_0(manufacturer_code)
        end    
    end

  def generate_application_xml(dealership_id, manufacturer_code, model_code)
    xml = Builder::XmlMarkup.new
    return "" unless @lease_application.present?
    xml.MSI_APP_ORIG do |msi|
    ssn_busines_id = @lease_application.lessee&.ssn.blank? ? '999999999' : @lease_application.lessee&.ssn&.gsub(/[-,.\/\\()]/, '').gsub(' ', '')
      msi.LESSEE_RECORD do |d|
        d.localAddOnly(false)
        d.clientNumber(@lease_application.lessee_id)
        d.portfolio("1")
        d.company("1")
        d.region("1")
        d.office("1")
        d.name(@lease_application.lessee&.decorate&.display_name) 
        d.address1(@lease_application.lessee&.home_address&.street1)
        d.address2(@lease_application.lessee&.home_address&.street2)
        d.city(@lease_application.lessee&.home_address&.new_city_value)
        d.state(@lease_application.lessee&.home_address&.new_state_value)
        d.zipCode(@lease_application.lessee&.home_address&.zipcode)
        d.homePhone(@lease_application.lessee&.mobile_phone_number&.gsub(/[^0-9]/, ''))
        d.emailAddress(@lease_application.lessee&.email_address)
        d.papAcctType("CHKG")
        d.papInstID(@lease_application.payment_aba_routing_number)
        d.papAchType("PPD")
        d.papAccount(@lease_application.payment_account_number)
        d.prenoteSent("Y")
        d.datePrenotificationSentOn(@lease_application&.last_lease_document_request&.delivery_date&.strftime("%m%d%y")) 
        d.remittanceAddress("SL")
        d.billingName(@lease_application.lessee&.decorate&.display_name)
        d.billingAddress1(@lease_application.lessee&.home_address&.street1)
        d.billingAddress2(@lease_application.lessee&.home_address&.street2)
        d.billingCity(@lease_application.lessee&.home_address&.new_city_value)
        d.billingState(@lease_application.lessee&.home_address&.new_state_value)
        d.billingZipCode(@lease_application.lessee&.home_address&.zipcode)
        d.useTaxExemptCode("NONE")
        d.ssnBusinessID(ssn_busines_id)
        d.shortname(@lease_application.lessee&.decorate&.short_name)
        d.activityStatus("ACTV")
        d.addressType("Y")
        d.addressStatus("C") 
        d.busIndicator("Y")   
        d.paymentDueDay(@lease_application&.first_payment_date&.prev_month&.strftime("%d"))
      end

      client_number = @lease_application.dealer&.dealership&.access_id.present? ? @lease_application.dealer&.dealership&.access_id  : @lease_application.dealer&.dealership&.id 

      msi.VENDOR_RECORD do |d|
         d.localAddOnly(false)
         d.portfolio("1")
         d.company("1")
         d.region("1")
         d.office("1")
         d.clientNumber(dealership_id)
         d.name(@lease_application.dealer&.dealership&.name)
         d.address1(@lease_application.dealer&.dealership&.address&.street1)
         d.address2(@lease_application.dealer&.dealership&.address&.street2)
         d.city(@lease_application.dealer&.dealership&.address&.city)
         d.state(@lease_application.dealer&.dealership&.address&.state)
         d.zipCode(@lease_application.dealer&.dealership&.address&.zipcode)
         d.busPhone(@lease_application.dealer&.dealership&.primary_contact_phone&.gsub(/[^0-9]/, ''))
         d.emailAddress(@lease_application.dealer&.email)
         d.shortname(@lease_application.dealer&.first_name&.upcase)
       end
       
       msi.BROKER_RECORD do |d|
         d.localAddOnly(false)
         d.portfolio("1")
         d.company("1")
         d.region("1")
         d.office("1")
         d.clientNumber(dealership_id)
         d.address1(@lease_application.dealer&.dealership&.address&.street1)
         d.address2(@lease_application.dealer&.dealership&.address&.street2)
         d.city(@lease_application.dealer&.dealership&.address&.city)
         d.state(@lease_application.dealer&.dealership&.address&.state)
         d.zipCode(@lease_application.dealer&.dealership&.address&.zipcode)
         d.busPhone(@lease_application.dealer&.dealership&.primary_contact_phone&.gsub(/[^0-9]/, ''))
         d.activityStatus("ACTV")
         d.ssnBusinessID(ssn_busines_id)
         d.shortname(@lease_application.dealer&.first_name&.upcase)
       end
       
    setting = Make.find_by_id(@lease_application.lease_calculator&.asset_make)&.application_setting
    security_deposit = setting&.enable_global_security_deposit ? "$#{setting.global_security_deposit.to_s}" :
                           "$#{@lease_application&.lease_calculator&.refundable_security_deposit.to_s}"
    resid_percent =(@lease_application&.lease_calculator&.customer_purchase_option/@lease_application&.lease_calculator&.adjusted_capitalized_cost)*100
    acquisition_cost = @lease_application&.lease_calculator&.calculate_gross_capitalized_cost - @lease_application&.lease_calculator&.acquisition_fee

    credit_tier_value = (@lease_application&.lease_calculator&.credit_tier_v2&.description).split(' ').second
    lpc_insurance_premium_cost = (@lease_application&.lease_calculator&.capitalized_cost_reduction_cents_lpc - @lease_application&.lease_calculator&.net_trade_in_allowance_cents).to_f/100      

      msi.APPLICATION_RECORD do |d|
        d.localAddOnly(false)
        d.portfolio("1")
        d.company("1")
        d.region("1")
        d.office("1")
        d.appNumber(@lease_application&.application_identifier)
        d.lessee(@lease_application.lessee_id)
        d.vendor(dealership_id)
        d.leaseDate(@lease_application&.last_lease_document_request&.delivery_date&.strftime("%m%d%y"))
        d.commencementDate(@lease_application&.first_payment_date&.prev_month&.strftime("%m%d%y"))             
        d.disbursementDate(@lease_application&.funded_on&.strftime("%m%d%y"))
        d.lessorAccrualMethod("AOSL")
        d.leaseSource("DRCT")
        d.advancePaymentBegins(1)
        d.delinquencyWatchCode(1)
        d.leaseTypeCode("OPER")
      # d.upfrontSalesTaxCode(@lease_application&.lease_calculator&.monthly_sales_tax.present? ? "FIN" : "")
        d.upfrontSalesTaxCode("FIN")
        d.businessPersonal("P")
        d.openCloseLeaseType("C")
        d.statementCode("I")
        d.automaticChargeOff("N")
        d.generalDescription(@lease_application&.last_lease_document_request&.general_description)
        d.securityDeposit(security_deposit)
        d.residual(@lease_application&.lease_calculator&.customer_purchase_option)
        d.residPercent(resid_percent)
        d.billingLevel("L")
        d.term(@lease_application&.lease_calculator&.term)
        d.gracePeriodInDays(11)
       # d.upfrontSalesTaxOnCost(@lease_application&.lease_calculator&.upfront_tax)
        d.acquisitionCost(acquisition_cost)
        d.paymentFreq('MON')
        d.insurancePremiumPayTo(lpc_insurance_premium_cost < 0 ? "D#{client_number}" : "")        
        d.creditQuality(credit_tier_value)
        d.dealerSubsidyIncome(@lease_application&.lease_calculator&.acquisition_fee)
        d.subvention(@lease_application&.lease_calculator&.net_trade_in_allowance > 0 ? @lease_application&.lease_calculator&.net_trade_in_allowance : 0)
        d.notaryFeeCost(@lease_application&.lease_calculator&.dealer_reserve)
        d.insurancePremium(lpc_insurance_premium_cost < 0 ? lpc_insurance_premium_cost.abs : 0)
        d.notaryFeePayable(dealership_id)
        d.registrationFeeIncome(@lease_application&.lease_calculator&.cash_down_payment > 0 ? @lease_application&.lease_calculator&.cash_down_payment : 0)
        d.useTaxExemptCode('NONE')
        d.payment_Freq_0(1)
        d.payment_Freq_1(@lease_application&.lease_calculator&.term.to_i - 1)
        d.payment_Amount_0(@lease_application&.lease_calculator&.base_monthly_payment)
        d.payment_Amount_1(@lease_application&.lease_calculator&.base_monthly_payment)
        d.payment_Code_0("ADVM")
        d.payment_Code_1("MON")
        d.npvDiscountRate(@lease_application&.lease_calculator&.npv_discount_rate)
        # d.clientRelationshipType_0("LES")
        # d.client_Number_0(@lease_application.lessee_id)
        # d.clientRelationshipType_1(@lease_application&.colessee_id.present? ? "C" : "")
        # d.client_Number_1(@lease_application.colessee_id.present? ? @lease_application.colessee_id : "")
        d.openingCommission(@lease_application&.lease_calculator&.servicing_fee)
        d.preauthSwitch("Y")
        d.dueDate(@lease_application&.first_payment_date&.prev_month&.strftime("%d"))
        d.metro2FileFormat("TRAN")
        unless @lease_application&.lessee&.form_code&.strip&.empty?
          d.formCode(@lease_application&.lessee&.form_code)
          d.lateChargeAsmt(@lease_application&.lessee&.late_charge_asmt)
        end
      end

      acquisition_cost = @lease_application&.lease_calculator&.calculate_gross_capitalized_cost - @lease_application&.lease_calculator&.acquisition_fee
      code = format('%02d', @lease_application&.lease_calculator&.term.to_i/12)
      asset_number = @lease_application.application_identifier.split(//).last(9).join
      upfront_sales_tax_base_amt = if @lease_application&.lease_calculator&.monthly_sales_tax == 0
                                     @lease_application&.lease_calculator&.calculate_gross_capitalized_cost - @lease_application&.lease_calculator&.upfront_tax
                                   else
                                     ""
                                   end
      upfront_sales_tax_state = @lease_application&.lease_calculator&.upfront_tax == 0 ? "" : @lease_application.upfront_sales_tax_state
      upfront_taxes_and_geocodes =  @lease_application.upfront_taxes_and_location_geocodes 
      insurance_expiration_date = @lease_application.insurance&.expiration_date.present? ? @lease_application.insurance&.expiration_date.strftime("%m%d%y") : "010125"

      msi.ASSET_RECORD do |d|
       # d.upfrontSalesTaxStRate(@lease_application&.lease_calculator&.upfront_tax == 0 ? "" : upfront_taxes_and_geocodes[:state].to_s )
       # d.upfrontSalesTaxCountyRate(@lease_application&.lease_calculator&.upfront_tax == 0 ? "" : upfront_taxes_and_geocodes[:county].to_s)
       # d.upfrontSalesTaxCityRate(@lease_application&.lease_calculator&.upfront_tax == 0 ? "" : upfront_taxes_and_geocodes[:city].to_s)
       # d.upfrontSalesTaxCounty(@lease_application&.lease_calculator&.upfront_tax == 0 ? "" : upfront_taxes_and_geocodes[:county_geocode].to_s)
       # d.upfrontSalesTaxCity(@lease_application&.lease_calculator&.upfront_tax == 0 ? "" : upfront_taxes_and_geocodes[:city_geocode].to_s)
        d.localAddOnly(false)
        d.assetNumber("9#{asset_number}")
        d.applicationNumber(@lease_application&.application_identifier)
        d.identification(@lease_application&.last_lease_document_request&.asset_vin)
        d.supplier(dealership_id)
        d.acquisitionDate(@lease_application&.last_lease_document_request&.delivery_date&.strftime("%m%d%y"))
        d.acquisitionCost(acquisition_cost)
        d.inServiceDate(@lease_application&.last_lease_document_request&.delivery_date&.strftime("%m%d%y"))
        d.bookDepreciationDate(@lease_application&.last_lease_document_request&.delivery_date&.strftime("%m%d%y"))
        d.assetClass("V")
        d.manufacturer(manufacturer_code)
        d.model(model_code)
        d.year(@lease_application&.last_lease_document_request&.asset_year.to_s.last(2))
        d.locationState(@lease_application.upfront_sales_tax_state)
        d.locationCounty(upfront_taxes_and_geocodes[:county_geocode].to_s)
        d.locationCity(upfront_taxes_and_geocodes[:city_geocode].to_s)
        d.taxPaymentCode(@lease_application&.lease_calculator&.monthly_sales_tax == 0 ? "NOPF" : "ALL")
        d.taxType("TLA")
      # d.upfrontSalesTaxState(upfront_sales_tax_state || ""  )
        d.newUsed("U")
        d.upfrontSalesTaxYN("N")
      # d.upfrontSalesTaxYN(@lease_application&.lease_calculator&.monthly_sales_tax == 0 ? "Y" : "N")
        d.description(@lease_application&.last_lease_document_request&.asset_model)
        d.residualCost(@lease_application&.lease_calculator&.customer_purchase_option)
        d.listPrice(@lease_application&.lease_calculator&.dealer_sales_price)
        d.bookSalvageValue(@lease_application&.lease_calculator&.customer_purchase_option)
        d.stateSalvageValue(@lease_application&.lease_calculator&.customer_purchase_option)
        d.bookTaxBasis(acquisition_cost)
       # d.upfrontSalesTaxBaseAmt(upfront_sales_tax_base_amt)
       # d.upfrontSalesTaxSlsTxAmt(@lease_application&.lease_calculator&.monthly_sales_tax == 0 ? @lease_application&.lease_calculator&.upfront_tax : "")
        d.insuranceExprDate(insurance_expiration_date)
        d.insurancePremiumCost(lpc_insurance_premium_cost < 0 ? lpc_insurance_premium_cost.abs : 0)
        d.bookAccountingMethod('OPER')
        d.bookDepreciationMethod("SL#{code}")
        d.federalMethodOfDepreciation("SL#{code}")
        d.federalAMTMethod("SL#{code}")
        d.stateDepreciationMethod("SL#{code}")
        d.itcTakeBypassCode("BYPS")
        d.pptExemptCode('NONE')
        d.useTaxExemptCode('NONE')
        d.address1(@lease_application.lessee&.home_address&.street1)
        d.address2(@lease_application.lessee&.home_address&.street2)
        d.city(@lease_application.lessee&.home_address&.new_city_value)
        d.state(@lease_application.lessee&.home_address&.new_state_value)
        d.zipCode(@lease_application.lessee&.home_address&.zipcode)
        d.dealerBonus(@lease_application&.lease_calculator&.net_trade_in_allowance < 0 ? @lease_application&.lease_calculator&.net_trade_in_allowance : 0)
        d.dealerBonusPayTo(@lease_application&.lease_calculator&.net_trade_in_allowance < 0 ? dealership_id : "")    
        d.uccTitleFilingTerm_0(@lease_application&.lease_calculator&.term)
        d.uccTitleFilingNumber_0(@lease_application&.last_lease_document_request&.asset_vin)
        d.uccTitleFilingType_0('VEH')
        d.uccTitleFilingState_0(@lease_application&.lessee&.home_address&.new_state_value)
        d.uccTitleFilingCode_0('FPNW')
        d.uccTitleFilingDate_0(@lease_application.funding_approved_on&.strftime("%m%d%y"))
      # d.upfrontTaxDestState(@lease_application.upfront_sales_tax_state)
        #d.assetStatus('AINV')
      end

      insurance_policy_eff_date = @lease_application.insurance&.effective_date.present? ? @lease_application.insurance&.effective_date.strftime("%m%d%y") : @lease_application&.last_lease_document_request&.delivery_date&.strftime("%m%d%y")
      insurance_company_code = @lease_application.insurance&.insurance_company&.company_code.present? ? @lease_application.insurance&.insurance_company&.company_code : 'GEIC'
      insurance_status = @lease_application.insurance.nil? ? "EXP " : ( (Date.today >= @lease_application.insurance&.effective_date) && (Date.today <= @lease_application.insurance&.expiration_date) ) ? "BIND" : "EXP "
      
      msi.INSURANCE_RECORD do |d|
        d.localAddOnly(false)
        d.appLeaseNumber(@lease_application.application_identifier)
        d.finalCreditScore(@lease_application.lessee&.highest_fico_score)
        d.recordType("A")
        d.insuranceCarrierName_0(@lease_application.insurance&.company_name)
        d.insuranceCarrierCode_0(insurance_company_code)
        d.insuranceExpDate_0(insurance_expiration_date)
        d.insurancePolicyEffDate_0(insurance_policy_eff_date)
        d.insuranceType_0("FLCV")
        d.insuranceCoverageType_0("ALL")
        d.insuranceStatus_0(insurance_status)
      end

      msi.UDF_FIELDS_RECORD do |d|
        d.localAddOnly(false)
        d.udfKey(@lease_application.application_identifier)
        d.udfType('APP')
        d.udfField1(@lease_application&.lease_calculator&.dealer_sales_price)
        d.udfField3(@lease_application&.lease_calculator&.dealer_documentation_fee)
        d.udfField4(@lease_application&.lease_calculator&.title_license_and_lien_fee)
        d.udfField5(@lease_application&.lease_calculator&.upfront_tax)
        d.udfField6(@lease_application&.lease_calculator&.guaranteed_auto_protection_cost)
        d.udfField7(@lease_application&.lease_calculator&.prepaid_maintenance_cost)
        d.udfField8(@lease_application&.lease_calculator&.extended_service_contract_cost)
        d.udfField9(@lease_application&.lease_calculator&.tire_and_wheel_contract_cost)
        d.udfField10(@lease_application&.lease_calculator&.acquisition_fee)
        d.udfField11('SP')
      end   

      insurance_limits = @lease_application.insurance&.bodily_injury_per_person.to_money.to_f + @lease_application.insurance&.bodily_injury_per_occurrence.to_money.to_f + @lease_application.insurance&.property_damage.to_money.to_f
      
      msi.UDF_FIELDS_RECORD do |d|
        d.localAddOnly(false)
        d.udfKey(@lease_application.application_identifier.gsub(/^1/, "9"))
        d.udfType('UNI')
        d.udfField8(insurance_limits == 0 ? "0" : insurance_limits.to_i)
        d.udfField9('.01')
        d.udfField10('.01')
        d.udfField11(@lease_application.insurance&.comprehensive.present? ? @lease_application.insurance&.comprehensive : '0.01')
        d.udfField12(@lease_application.insurance&.collision.present? ? @lease_application.insurance&.collision : '0.01')
        d.udfField13(@lease_application.insurance&.additional_insured == true ? 'YES' : 'NO')
        d.udfField14(@lease_application.insurance&.loss_payee == true ? 'YES' : 'NO')
      end
    end
  end

  def generate_disbursement_date_xml
    xml = Builder::XmlMarkup.new
    return "" unless @lease_application.present?
    xml.MSI_APP_ORIG do |msi|
        msi.APPLICATION_RECORD do |d|
        d.localAddOnly(false)
        d.appNumber(@lease_application&.application_identifier)
        d.disbursementDate(@lease_application&.funded_on&.strftime("%m%d%y"))
        if @lease_application.payment_frequency == 'split'
            d.papInstitutionACHtransitID(@lease_application.payment_aba_routing_number)
            d.papAccountNumber(@lease_application.payment_account_number)
            d.papBankAccountName('PRIMARY')
            d.papEffectiveDate(@lease_application&.first_payment_date&.prev_month&.strftime("%m%d%y"))
         end   
        end
    

     msi.INSURANCE_RECORD do |d|
        d.localAddOnly(false)
        d.appLeaseNumber(@lease_application.application_identifier)
        d.policyNumber_0(@lease_application.insurance&.policy_number)
        end
    end
  end

  def generate_payment_schedule_load_xml
    xml = Builder::XmlMarkup.new
    return "" unless @lease_application.present?
    term = @lease_application.lease_calculator&.term
    payment_amount = @lease_application.lease_calculator.total_monthly_payment_cents.to_f/200
    first_payment_date = @lease_application.first_payment_date
    second_payment_date = @lease_application.second_payment_date
    days_difference = (second_payment_date - first_payment_date).to_i \
      if first_payment_date.present? && second_payment_date.present?
    counter = 1

    xml.PAP_INTVSCH_RECORD do |d|
      d.appLseNumber(@lease_application.application_identifier)
      d.enabled('Y')
      (0...((term * 2) - 2) / 2).each do |i|
        if first_payment_date.present?
          d.__send__("dueDate_#{counter}") do 
            d << (first_payment_date + i.month).strftime("%m%d%y")
          end

          d.__send__("amount_#{counter}") do 
            d << payment_amount.to_f.round(2).to_s
          end
        end

        counter += 1

        if first_payment_date.present? && second_payment_date.present? 
          d.__send__("dueDate_#{counter}") do 
            d << (first_payment_date + i.month + days_difference).strftime("%m%d%y")
          end

          d.__send__("amount_#{counter}") do 
            d << payment_amount.to_f.round(2).to_s
          end
        end

        counter += 1
      end
    end   
  end

  # generate XML data
  def generate_status_xml(status)

    status = status.split(",")

    appNumber = status[0].split("=>")[1].gsub!('"', '').strip
    dapcksum = status[1].split("=>")[1].gsub!('"', '').strip
    ddmcksum = status[2].split("=>")[1].gsub!('"', '').gsub!('}', '').strip

    
    xml = Builder::XmlMarkup.new

    xml.APP_STATUS_XFER do |d|
      d.appNumber(appNumber)
      d.dapcksum(dapcksum)
      d.ddmcksum(ddmcksum)
      if (@lease_application.document_status == 'funded' && @lease_application.funded_on.present?)
        d.newStatus(@lease_application.dealership.is_commission_clawback? ? 'APMB' : 'APBK')
      else  
        d.newStatus('EFA ')
      end  
    end
  end
end
