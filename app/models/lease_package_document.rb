require 'fileutils'
class LeasePackageDocument < PdfDocument
  cattr_accessor :fields

  CHECKED = "Yes".freeze
  UNCHECKED = "Off".freeze
  ZERO = 0.freeze
  AS_PER_ATTACHED = "As per attached contract".freeze

  attr_reader :deal, :customer, :cosigner, :dealership, :calculator, :references, :last_lease_document_request

  text('Lessee1 Name') { customer.full_name_with_middle_initial }
  text('LeaseNumber') { deal.application_identifier }
  text('Applicant E-mail Address') { customer.email_address }  
  checkbox('Check - Single') { UNCHECKED }
  checkbox('Check - Monthly') { CHECKED }

  text('Lessor Name') { dealership.name }  
  text('Applicant DOB') { customer.date_of_birth } #docme
  text('Applicant SSN') { customer.ssn } #docme
  text('Lessor Address 1') { dealership.address.street1_street2 }  
  text('Lessor Address 2') { dealership.address.city_state_zip }
  text('Lessor Address 2 City') { dealership.address.city }
  text('Lessor Address 2 State') { dealership.address.state&.upcase }
  text('Lessor Address 2 Zip Code') { dealership.address.zipcode }

  text('Lessee1 Address 1') { customer.home_address.street1_street2 }  
  text('Lessee1 Address 2') { customer.home_address.city_state_zip }  
  text('Lessee 1 Address 2 City') { customer.home_address&.new_city_value }
  text('Lessee 1 Address 2 State') { customer.home_address&.new_state_value }
  text('Lessee 1 Address 2 Zip Code') { customer.home_address.zipcode }
  text('Lessee2 Name') { cosigner.full_name_with_middle_initial if cosigner }  
  text('Lessee2 Address 1') { cosigner.home_address.street1_street2 if cosigner && cosigner.home_address }  
  text('Lessee2 Address 2') { cosigner.home_address.city_state_zip if cosigner && cosigner.home_address }  
  text('Lessee2 Address2 City') { cosigner.home_address.new_city_value if cosigner && cosigner.home_address }
  text('Lessee2 Address2 County') { cosigner.home_address.new_county_value if cosigner && cosigner.home_address }
  text('Lessee2 Address2 Zip Code') { cosigner.home_address.zipcode if cosigner && cosigner.home_address }
  text('County') { customer.county }  

  text('Joint/Cosinger County') { cosigner.try(:county) }

  text('Joint/Cosinger DOB') { cosigner.date_of_birth if cosigner } #docme
  text('Joint/Cosinger SSN') { cosigner.ssn if cosigner } #docme
  text("Joint/Cosinger DLN") { cosigner.drivers_license_id_number if cosigner }
  text('Joint/Cosinger How Long') { "#{cosigner.stay_length} months" unless cosigner.nil? || cosigner.stay_length.blank? }
  checkbox("Joint/Cosinger Own Rent Other") { cosigner.addr_stat unless cosigner.nil? || cosigner.addr_stat.blank? }
  dollars("Joint/Cosinger Monthly Residence Payment") { cosigner.monthly_pymt unless cosigner.nil? }
  text("Joint/Cosinger Home/Cell Number") { (cosigner.home_phone.blank? ? cosigner.cell_phone : cosigner.home_phone) unless cosigner.nil? }
  checkbox("Joint/Cosinger Mailing Address Same") { "Same" if cosigner && cosigner.use_phy_addr }
  text("Joint/Cosinger Mailing Address") { cosigner.mailing_address.try(:address) unless cosigner.nil? }
  text("Joint/Cosinger Mailing City") { cosigner.mailing_address.try(:new_city_value) unless cosigner.nil? }
  text("Joint/Cosinger Mailing State") { cosigner.mailing_address.try(:new_state_value) unless cosigner.nil? }
  text("Joint/Cosinger Mailing Zip") { cosigner.mailing_address.try(:zipcode) unless cosigner.nil? }
  text("Joint/Cosinger Mailing County") { cosigner.mailing_address.try(:new_county_value) unless cosigner.nil? }

  checkbox("Joint/Cosinger Employment Status") { cosigner&.employment_status_definition&.definition unless cosigner.nil? }
  text("Joint/Cosinger Employer") { cosigner.emp_name unless cosigner.nil? }
  text("Joint/Cosinger Employment City") { cosigner.employment_address&.city unless cosigner.nil? }
  text("Joint/Cosinger Employment State") { cosigner.employment_address&.state unless cosigner.nil? }
  text("Joint/Cosinger Business Phone") { cosigner.employer_phone_number unless cosigner.nil? }

  text("Joint/Cosinger Years/Months There") { cosigner.emp_length unless cosigner.nil? }
  dollars("Joint/Cosinger Gross Income") { cosigner.gross_monthly_income unless cosigner.nil? }
  dollars("Joint/Cosinger Other Income") { cosigner.other_monthly_income unless cosigner.nil? }

  date('TodaysDate') { last_lease_document_request.delivery_date }  

  checkbox('Refer') { UNCHECKED }

  text('B-Year') { last_lease_document_request.asset_year }
  text('B-Make') { last_lease_document_request.asset_make }  
  text('B-Model') { last_lease_document_request.asset_model }  
  text('B-Color') { last_lease_document_request.asset_color } #docme
  text('B-Style') { "MOTORCYCLE" }  
  text('B-VIN') { last_lease_document_request.asset_vin }  
  integer('B-Mileage') { last_lease_document_request.exact_odometer_mileage }  

  text('T-Year') { last_lease_document_request.trade_in_year }
  text('T-Make') { last_lease_document_request.trade_in_make }
  text('T-Model') { last_lease_document_request.trade_in_model }  
  
  text('EQUIPPED WITH') { last_lease_document_request.equipped_with }

  dollars('TradeInPayoff') { calculator.trade_in_payoff.to_d } 
  dollars('PriorCredit') { calculator.trade_in_payoff.to_d }  # Deprecated
  checkbox('Purpose') { UNCHECKED }

  dollars('GrossTradeInAllowance') { calculator.gross_trade_in_allowance }  
  dollars('NetTradeInAllowance') { calculator.net_trade_in_allowance }  

  dollars('TotalMonthlyPayment')  { calculator.total_monthly_payment }  

  text('1st Due Date') { last_lease_document_request.first_monthly_payment_due_on_presenter }

  integer('RemainingPaymentsAtSigning') { calculator.remaining_payments_at_signing }  

  text('Due Date') { last_lease_document_request.second_monthly_payment_day } #docme
  text('Split Payment 1') { last_lease_document_request&.second_monthly_payment_day&.to_i > last_lease_document_request&.second_ach_day&.to_i ? last_lease_document_request.second_ach_day : last_lease_document_request&.second_monthly_payment_day }
  text('Split Payment 2') { last_lease_document_request&.second_monthly_payment_day&.to_i > last_lease_document_request&.second_ach_day&.to_i ? last_lease_document_request.second_monthly_payment_day : last_lease_document_request.second_ach_day }
  date('Beginning On') { last_lease_document_request.recurring_payment_begins_on }
  text('2nd ACH') { last_lease_document_request.second_ach_day }

  dollars('Sum of All Payments') { calculator.sum_of_all_payments }
  dollars('PreTaxPaymentsSum') { calculator.pre_tax_payments_sum }
  dollars('Lease Total Payments') { calculator.lease_total_payments }

  dollars('DealerSalesPricePlusFreightAndSetup') { calculator.dealer_sales_price + calculator.dealer_freight_and_setup }  

  dollars('GrossCapCost') { calculator.gross_capitalized_cost }
  dollars('Tot Gross Cap Cost') { calculator.gross_capitalized_cost } # Deprecated
  dollars('AdjustedCapCost') { calculator.adjusted_capitalized_cost } #docme
  dollars('Requested Amount') { calculator.adjusted_capitalized_cost } #docme # Deprecated
  dollars('CustomerPurchaseOption') { calculator.customer_purchase_option }  
  dollars('MonthlyDepreciation') { calculator.monthly_depreciation_charge }
  dollars('Monthly Depreciation') { calculator.monthly_depreciation_charge } # Deprecated
  dollars('TotalDepreciation') { calculator.adjusted_capitalized_cost - calculator.customer_purchase_option }
  dollars('Total Depreciation') { calculator.adjusted_capitalized_cost - calculator.customer_purchase_option } # Deprecated
  dollars('TotalRentCharge') { calculator.total_rent_charge }
  checkbox("Individual/Joint/Cosigner") { cosigner.present? ? "Joint" : "Individual" }

  integer('Term') { calculator.term }
  dollars('BasePayment') { calculator.base_monthly_payment }
  dollars('MonthlySalesUseTax') { calculator.monthly_sales_tax }

  text('Excessive Mileage') { "unlimited" }
  dollars('Excessive Mileage Cost') { ZERO }
  checkbox('Purchase Option Box') { CHECKED }

  dollars('Taxes') { calculator.upfront_tax }  
  dollars('TitleLicRegFees') { calculator.title_license_and_lien_fee }  
  dollars('CopyWarranty & Service Con', 'CopyWarranty &amp; Service Con') { calculator.extended_service_contract_cost + calculator.prepaid_maintenance_cost }
  dollars('ExtendedServiceContractCost') { calculator.extended_service_contract_cost }  
  dollars('Documentation Fees') { calculator.dealer_documentation_fee }  

  dollars('Acquisition fee', 'Acquisition Fee') { calculator.acquisition_fee }
  text('Other Cost Name 1') { "GAP" }
  text('Other Cost Name 2') { "Breakdown Ins" }
  dollars('GapCost') { calculator.guaranteed_auto_protection_cost }  
  dollars('GPS Cost') { calculator.gps_cost }    
  dollars('PrePaidMaintCost') { calculator.prepaid_maintenance_cost } #docme  
  dollars('TireAndWheelPrice') { calculator.tire_and_wheel_contract_cost }  

  checkbox('Service Contract Box') { calculator.extended_service_contract_cost_cents > 0 ? CHECKED : UNCHECKED }
  text('Warranty Coverage') { AS_PER_ATTACHED }
  integer('Service Term') { [last_lease_document_request.tire_contract_term, last_lease_document_request.service_contract_term, last_lease_document_request.ppm_contract_term].compact.reject { |term| term <= ZERO}.min || ZERO }
  text('months') { "months" }
  text('Service Contract Coverage') { AS_PER_ATTACHED }

  checkbox('Gap Insurance Box') { last_lease_document_request.gap_contract_term.to_i > ZERO ? CHECKED : UNCHECKED }
  integer('GapTerm') { last_lease_document_request.gap_contract_term }

  checkbox('Mech Breakdown Box') { calculator.prepaid_maintenance_cost.to_i > ZERO ? CHECKED : UNCHECKED }
  integer('Warranty Term') { last_lease_document_request.ppm_contract_term if calculator.prepaid_maintenance_cost.to_i > ZERO }

  checkbox('Extended Warranty Box') { calculator.tire_and_wheel_contract_cost.to_i > ZERO ? CHECKED : UNCHECKED }
  integer('Breakdown Term') { last_lease_document_request.tire_contract_term if calculator.tire_and_wheel_contract_cost.to_i > ZERO }

  text('Gap Coverage Description') { AS_PER_ATTACHED if last_lease_document_request.gap_contract_term.to_i > ZERO }
  dollars('Svc Charge on Deposit') { 10 }
  dollars('Total Taxes Over Term') { calculator.upfront_tax + calculator.title_license_and_lien_fee + (calculator.monthly_sales_tax * calculator.term) }
  checkbox('Svc Charge Security Box') { CHECKED }

  dollars('TwicePerMonth') { calculator.total_monthly_payment * 0.5 }
  dollars('DueAtSign1') { ZERO }

  dollars('SecurityDeposit') { calculator.refundable_security_deposit }  
  dollars('AcquisitionFeeAtSign') { ZERO }
  dollars('DocFeesAtSign') { ZERO }

  dollars('DueAtSign2') { ZERO }
  dollars('DueAtSign3') { ZERO }
  dollars('DueAtSign4') { ZERO }

  dollars('RegistrationFeeAtSign') { ZERO }
  dollars('DueAtSign5') { ZERO }
  dollars('TitleFeeAtSign') { ZERO }
  dollars('DueAtSign6') { ZERO }
  dollars('DueAtSign7') { ZERO }
  dollars('Rebates') { calculator.rebates_and_noncash_credits }
  dollars('CashAtSign') { calculator.total_cash_at_signing }
  dollars('TotalAtSign') { calculator.total_at_sign }

  text("Applicant DLN") { customer.drivers_license_id_number }
  text('Applicant How Long') { "#{customer.stay_length} months" unless customer.stay_length.blank? }
  checkbox("Applicant Own Rent Other") { customer.addr_stat unless customer.addr_stat.blank? }
  dollars("Applicant Monthly Residence Payment") { customer.monthly_pymt }
  text("Applicant Home/Cell Number") { customer.home_phone_number.blank? ? customer.mobile_phone_number : customer.home_phone_number }
  text("Applicant Mailing Address Same") { "Same" unless customer.mailing_address.present? }
  text("Applicant Mailing Address") { customer.mailing_address&.address }
  text("Applicant Mailing City") { customer.mailing_address&.new_city_value }
  text("Applicant Mailing State") { customer.mailing_address&.new_state_value }
  text("Applicant Mailing Zip") { customer.mailing_address&.zipcode }
  text("Applicant Mailing County") { customer.mailing_address&.new_county_value }

  checkbox("Applicant Employment Status") { customer&.employment_status_definition&.definition }
  text("Applicant Employer") { customer.employer_name }
  text("Applicant Employment City") { customer.employment_address&.city }
  text("Applicant Employment State") { customer.employment_address&.state }
  text("Applicant Business Phone") { customer.employer_phone_number }

  text("Applicant Years/Months There") { customer.emp_length }
  dollars("Applicant Gross Income") { customer.gross_monthly_income }
  dollars("Applicant Other Income") { customer.other_monthly_income || 0.0}
  
  4.times do |i|
    text("Reference Name 0#{i+1}")         { references[i]&.full_name }
    text("Reference Phone Number 0#{i+1}") { references[i]&.phone_number }
    text("Reference City 0#{i+1}")         { references[i]&.city }
    text("Reference State 0#{i+1}")        { references[i]&.state }
  end

  dollars('InvDealerParticipation') { calculator.dealer_reserve }
  dollars('RemitToDealer') { calculator.remit_to_dealer }  
  text('Dealership Phone') { dealership.primary_contact_phone }
  dollars('DealFee') { dealership.deal_fee }

  text('FreightDash') { '--' } #docme

  text('Body Style') { 'MC' } #docme

  dollars("InvBalanceDue") { calculator.remit_to_dealer - calculator.dealer_reserve }
  dollars("CashDownPayment") { calculator.cash_down_payment }  
  dollars('CashDownPlusNetTradeInAllowance') { calculator.cash_down_payment + calculator.net_trade_in_allowance }  
  dollars('BalanceDueOnMotorcycleDeal') { calculator.balance_due_on_motorcycle_deal }  
  dollars("SubTotInvoicedItems") { calculator.total_sales_price - calculator.upfront_tax }
  dollars("SubTotReceived") { [calculator.total_monthly_payment, calculator.refundable_security_deposit, calculator.net_trade_in_allowance, calculator.cash_down_payment].sum }

  dollars("TaxableAmount") { calculator.dealer_sales_price - calculator.gross_trade_in_allowance }
  dollars("Sum of PreTax Payments") { calculator.base_monthly_payment * calculator.term }
  dollars('Total of Pre Tax Payments') { calculator.base_monthly_payment * calculator.term } # Deprecated
  dollars("ServicingFeeAmt") { calculator.servicing_fee }  

  dollars('TotalSalesPrice') { calculator.total_sales_price }

  text('Promotion Name') {deal.promotion_name}
  text('Promotion Value') {deal.promotion_value}

  checkbox("Check New") { calculator.new_used.eql?('New') ? CHECKED : UNCHECKED }
  checkbox("Check Used") { calculator.new_used.eql?('Used') ? CHECKED : UNCHECKED }
  checkbox("TMU Checkbox") { calculator.mileage_tier.eql?('TMU - True Mileage Unknown') ? CHECKED : UNCHECKED }

  signature("*Signature1*") { "*Signature1*" }
  signature("*Signature2*") { "*Signature2*" }
  signature("*Signature3*") { "*Signature3*" }
  text("*Bank Name*") { "*Bank Name*" }
  text("*Bank Branch Location*") { "*Bank Branch Location*" }
  text("*Bank Routing Number*") { "*Bank Routing Number*" }
  text("*Bank Account Number*") { "*Bank Account Number*" }
  text("*Signer1 radio1*") { "*Signer1 radio1*" }
  text("*Signer1 radio2*") { "*Signer1 radio2*" }
  text("*Signer1 radio3*") { "*Signer1 radio3*" }
  text("*Signer1 radio4*") { "*Signer1 radio4*" }
  text("*Signer1 radio5*") { "*Signer1 radio5*" }
  text("*Signer1 radio6*") { "*Signer1 radio6*" }
  text("*Signer1 radio7*") { "*Signer1 radio7*" }
  text("*Dealer FullName*") { deal&.dealer&.full_name }
  text("*Signer3 Draw*") { "*Signer3 Draw*" }
  text("*Signer3 FrontTread*") { "*Signer3 FrontTread*" }
  text("*Signer3 RearTread*") { "*Signer3 RearTread*" }
  text("*Signer3 ThirdTread*") { "*Signer3 ThirdTread*" }
  text("*Signer3 VehicleCondition*") { "*Signer3 VehicleCondition*" }
  text("*Signer1 VehicleCondition*") { "*Signer1 VehicleCondition*" }
  text("*Approve*") { "*Approve*" }
  text("*Signer1 Draw*") { "*Signer1 Draw*" }
  text("*Approver Attachment*") { "*Approver Attachment*" }
  text("*Lessee Attachment*") { "*Lessee Attachment*" }
  text("*Signature1 Date*") { "*Signature1 Date*" }
  text("*Signature2 Date*") { "*Signature2 Date*" }
  text("*Signature3 Date*") { "*Signature3 Date*" }

  def initialize(lease_application)
    @deal = lease_application
    @customer = @deal.lessee
    @cosigner = @deal.colessee
    @dealership = @deal.dealership
    @calculator = @deal.lease_calculator
    @references = @deal.references
    @last_lease_document_request = LeaseDocumentRequestDecorator.new(deal.last_lease_document_request)
  end

  def customer_templates
    LeasePackageTemplate.enabled.for_state(
      States::NAMES_TO_ABBREVIATIONS.invert[customer.home_address.new_state_value.upcase]
    ).customer.order(:position)
  end

  def dealership_templates
    templates = LeasePackageTemplate.enabled.for_state(
      States::NAMES_TO_ABBREVIATIONS.invert[dealership.address.new_state_value.upcase]
    ).dealership.order(:position)
    calculation_name = dealership&.remit_to_dealer_calculation&.calculation_name
    bill_of_sale_name = calculation_name == 'SLC Partner Lease' ? ENV['SLC_TEMPLATE_STANDARD'].split(",") : ENV['SLC_TEMPLATE_PARTNER'].split(",")
    templates.where.not(name: bill_of_sale_name).order(:position)
  end

  def all_templates
    (dealership_templates | customer_templates).sort_by(&:position)
  end

  #Will download files and store them in CarrierWave's Cache Dir if the files aren't local/cached already
  def local_template_paths
    # all_templates.map(&:local_template_path)
    valid_templates = all_templates.select { |temp| temp.lease_package_template.file.exists? }
    invalid_templates = all_templates.reject { |temp| temp.local_template_path if temp.lease_package_template.file.exists? }
    AdminMailer.notification_for_invalid_pdf_template(invalid_templates, valid_templates).deliver_now if invalid_templates.present?
  end

  #TODO - this is getting long and complex enough to be its own Ruby Class (PORO)
  def generate#_and_attach
    # step 1 - build filled in files
    #This Hash building is important because this keeps the Tempfiles "alive" by hooking them to this returned Hash.
    #Without this, Ruby's GC may garbage collect these orphaned temp files before they've had time to process below.
    #Yes this has happened...a lot actually.
    #Tempfiles are still awesome, they automatically clean themselves up, but we need to control when they're cleaned up!
    #See https://www.pivotaltracker.com/story/show/151932280
    local_template_paths
    filled_in_docs = all_templates.map(&:local_template_path).inject([]) do |memo, template_path|
      tempfile = Tempfile.new(["template_path_#{Time.now.to_i}", '.pdf'])
      tempfile.binmode
      memo.push({
        template_path: fill(template_path, tempfile.path),
        tempfile: tempfile
      })
    end

    filled_in_doc_paths = filled_in_docs.map{|hsh| hsh[:template_path]}

    return if filled_in_docs.empty?

    # step 2 - merge them together and attach to deal in one action
    output_file = Tempfile.new(["output_file_#{Time.now.to_i}", '.pdf'])
    output_file.binmode
    output_file #don't garbage collect?

    #this should be broken up.  Generate should return a File object containing the merged file.
    #attach to the deal in the background job/service object itself and remove this coupling
    #binding.pry

    #BUILD UPLOAD LEASE MERGED LEASE PACKAGE DOCUMENT
    #This File only exists in memory, never on the disk
    #TODO: TIGHT COUPLING HERE
    file = File.open(merge(filled_in_doc_paths, output_file.path), 'rb') do |f|
      @deal.lease_application_attachments.create({
        upload: f,
        visible_to_dealers: false,
        description: "Lease Package for #{customer.full_name} dated #{formatted_timestamp}"
      })
    end

    #CLEAN UP TEMPFILES, AS IS BEST PRACTICE
    filled_in_doc_paths = filled_in_docs.each do |hsh|
      hsh[:tempfile].close
      hsh[:tempfile].unlink
    end
    output_file.close
    output_file.unlink

    return file
  end

  def output_path
    file_name = "#{deal.application_identifier.to_s}_#{customer.full_name}"
    file_name << "_AND_#{cosigner.full_name}" if cosigner.present?
    file_name << ".pdf"
    file_name.gsub(' ', '_')
  end

end
