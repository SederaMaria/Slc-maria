require 'zip'

class ExportAccessDbJob
  include Sidekiq::Worker

  sidekiq_options unique:      :until_executed,
                  unique_args: :unique_args

  attr_reader :recipient, :csvs, :filter

  def self.unique_args(args)
    args[0]['email']
  end

  def perform(opts = {})
    @recipient   = opts.with_indifferent_access['email']
    @filter      = opts.with_indifferent_access['filter'] || {}
    @csvs        = {
      'applicants.csv' => generate_csv_one,
      'applications.csv' => generate_csv_two,
      'lease detail report.csv' => generate_csv_three,
    }
    update_exported
    zipfile_path = zip_files(csvs)
    email_to_recipient(zipfile_path)
    return zipfile_path
  end

  def email_to_recipient(filepath)
    DealerMailer.access_db_export(recipient: recipient, filepath: filepath).deliver_now
  end

  def zip_files(files)
    zipfile_path = "#{Rails.root.to_s}/tmp/access_db_export_#{SecureRandom.uuid}.zip"
    Zip::File.open(zipfile_path, Zip::File::CREATE) do |zipfile|
      files.each do |filename, filepath|
        zipfile.add(filename, filepath)
      end
    end
    return zipfile_path
  end

  # Applicants
  def generate_csv_one
    headers  = csv_one_mappings(LeaseApplication.first).keys
    filepath = "#{Rails.root.to_s}/tmp/export_access_db1_#{Time.now.to_i}.csv"
    CSV.open(filepath, 'wb', headers: true) do |csv|
      csv << headers
      LeaseApplication.ransack(filter).result.find_each do |application|
        csv << csv_one_mappings(application).values
      end
    end
    return filepath
  end

  # Applications
  def generate_csv_two
    headers  = csv_two_mappings(LeaseApplication.first).keys
    filepath = "#{Rails.root.to_s}/tmp/export_access_db2_#{Time.now.to_i}.csv"
    CSV.open(filepath, 'wb', headers: true) do |csv|
      csv << headers
      LeaseApplication.ransack(filter).result.find_each do |application|
        csv << csv_two_mappings(application).values
      end
    end
    return filepath
  end

  # Applications
  def generate_csv_three
    headers  = csv_three_mappings(LeaseApplication.first).keys
    filepath = "#{Rails.root.to_s}/tmp/export_access_db3_#{Time.now.to_i}.csv"
    CSV.open(filepath, 'wb', headers: true) do |csv|
      csv << headers
      LeaseApplication.ransack(filter).result.find_each do |application|
        csv << csv_three_mappings(application).values
      end
    end
    return filepath
  end

  # Applicants
  def csv_one_mappings(app)
    {
      'Applicant Number'  => '', #yes a blank string....
      'Primary Applicant' => app.lessee&.decorate&.display_name,
      'Primary SSN'       => remove_non_alphanumeric(app.lessee&.ssn),
      'Co Applicant'      => app&.colessee&.decorate&.display_name,
      'Co SSN'            => remove_non_alphanumeric(app&.colessee&.ssn),
      'Number and Street' => app.lessee&.home_address&.street1,
      'Unit'              => app.lessee&.home_address&.street2,
      'City'              => app.lessee&.home_address&.new_city_value,
      'State'             => app.lessee&.home_address&.new_state_value,
      'Zip'               => app.lessee&.home_address&.zipcode.try(:[], 0..4),
      'County'            => app.lessee&.home_address&.new_state_value,
      'Primary Phone'     => remove_non_alphanumeric(app.lessee&.mobile_phone_number),
      'Secondary Phone'   => remove_non_alphanumeric(app.colessee&.mobile_phone_number),
      'Email Address'     => app.lessee&.email_address,
      'Credit Score'      => app.lessee&.highest_fico_score,
      'Co Credit Score'   => app&.colessee&.highest_fico_score,
      'Credit Tier'       => app&.lease_calculator&.credit_tier_number,
      'Geocode State'     => (app&.city&.geo_state),
      'Geocode County'    => (app&.city&.geo_county),
      'Geocode City'      => (app&.city&.geo_city),
      'Gross Monthly Income'  => "",
      'Applicant Notes'       => "",
      'Bank Name'             => app&.payment_bank_name,
      'Bank Routing Number'   => app&.payment_aba_routing_number,
      'Bank Account Number'   => app&.payment_account_number,
      'Co Number and Street'  => app&.colessee&.home_address&.street1,
      'Co Unit'               => app&.colessee&.home_address&.street2,
      'Co City'               => app&.colessee&.home_address&.new_city_value,
      'Co State'              => app&.colessee&.home_address&.new_state_value,
      'Co Zip'                => app&.colessee&.home_address&.zipcode,
      'Co Email Address'      => app&.colessee&.email_address,
      'mail_returned'         => "",
      'phone_valid'           => "",
      'lessee_mobile_phone_number'       => remove_non_alphanumeric(app.lessee&.mobile_phone_number),
      'lessee_home_phone_number'         => remove_non_alphanumeric(app.lessee&.home_phone_number),
      'co_lessee_mobile_phone_number'    => remove_non_alphanumeric(app.colessee&.mobile_phone_number),
      'co_lessee_home_phone_number'      => remove_non_alphanumeric(app.colessee&.home_phone_number),

    }
  end

  # Applications
  def csv_two_mappings(app)
    {
      'Applicant Number'          => app.application_identifier,
      'Primary Applicant'         => app.lessee&.decorate&.display_name,
      'Application Received Date' => to_excel_serial_number(app.created_at),
      'Dealer'                    => app.dealer&.dealership&.name&.upcase,
      'Dealer Contact'            => app.dealer&.full_name&.upcase,
      'Requested Vehicle'         => app&.lease_calculator.decorate.vehicle_display_name,
      'Credit Decision Date'      => to_excel_serial_number(app.credit_decision_date),
      'Credit Decision'           => app&.credit_status&.humanize,
      'Credit Decision Notes'     => required_stipulations(app),
      'Lease Package Sent'        => to_excel_serial_number(app&.documents_issued_date),
      'Funding Amount'            => (app.documents_issued_date.present? ? app&.lease_calculator&.remit_to_dealer&.to_f : ''),
    }
  end

  # Leases
  def csv_three_mappings(app)
    setting = ApplicationSetting.first
    security_deposit = setting&.enable_global_security_deposit ? "$#{setting&.global_security_deposit}" :
                           "$#{app&.lease_calculator&.refundable_security_deposit.to_s}"
    {
      'Lease Number' =>                 app.application_identifier,
      'Primary Applicant' =>            app.lessee&.decorate&.display_name,
      'Vehicle Price' =>                "$#{app&.lease_calculator&.dealer_sales_price.to_s}",
      'Gross Capitalized Cost' =>       "$#{app&.lease_calculator&.calculate_gross_capitalized_cost.to_s}",
      'Capitalized Cost Reduction' =>   "$#{app&.lease_calculator&.calculate_capitalized_cost_reduction.to_s}",
      'Adjusted Capitalized Cost' =>    "$#{app&.lease_calculator&.adjusted_capitalized_cost.to_s}",
      'Total Cash' =>                   "$#{app&.lease_calculator&.cash_down_payment.to_s}",
      'Residual Value' =>               "$#{app&.lease_calculator&.customer_purchase_option.to_s}",
      'Security Deposit' =>             security_deposit,
      'Signing Lease Payment' =>        "$#{app&.lease_calculator&.total_monthly_payment.to_s}",
      'Upfront Sales Tax' =>            "$#{app&.lease_calculator&.upfront_tax.to_s}",
      'Title, License, Registration' => "$#{app&.lease_calculator&.title_license_and_lien_fee.to_s}",
      'Extended Warranty' =>            "$#{app&.lease_calculator&.extended_service_contract_cost.to_s}",
      'Documentation Fee' =>            "$#{app&.lease_calculator&.dealer_documentation_fee.to_s}",
      'Acquisition Fee' =>              "$#{app&.lease_calculator&.acquisition_fee.to_s}",
      'GAP Insurance' =>                "$#{app&.lease_calculator&.guaranteed_auto_protection_cost.to_s}",
      'Tire and Wheel Warranty' =>      "$#{app&.lease_calculator&.tire_and_wheel_contract_cost.to_s}",
      'Prepaid Maintenance' =>          "$#{app&.lease_calculator&.prepaid_maintenance_cost.to_s}",
      'Servicing Fee' =>                "$#{app&.lease_calculator&.servicing_fee.to_s}",
      'Trade Equity' =>                 "$#{app&.lease_calculator&.net_trade_in_allowance.to_s}",
      'Dealer Participation' =>         "$#{app&.lease_calculator&.dealer_reserve.to_s}",
      'Lease Date' =>                   app&.last_lease_document_request&.delivery_date&.to_s,
      'Lease Vehicle Year' =>           app&.last_lease_document_request&.asset_year.to_s,
      'Lease Vehicle Model' =>          app&.last_lease_document_request&.asset_model.to_s,
      'Lease Vehicle VIN' =>            app&.last_lease_document_request&.asset_vin.to_s,
      'Base Lease Payment' =>           "$#{app&.lease_calculator&.base_monthly_payment.to_s}",
      'Lease Payment Sales Tax' =>      "$#{app&.lease_calculator&.monthly_sales_tax.to_s}",
      'Total Lease Payment' =>          "$#{app&.lease_calculator&.total_monthly_payment.to_s}",
      'Lease Term' =>                   app&.lease_calculator&.term,
    }
  end

  def required_stipulations(app)
    app.lease_application_stipulations.required.map(&:decorate).map(&:with_notes).join(', ')
  end

  def remove_non_alphanumeric(string)
    return '' if string.blank?
    string.gsub(/[-,.\/\\()]/, '').gsub(' ', '')
  end

  def to_excel_serial_number(date)
    return '' if date.blank?
    excel_count_starts_on = Date.new(1899, 12, 30)
    (date.to_date - excel_count_starts_on).to_i.to_s
  end

  def update_exported
    LeaseApplication.ransack(filter).result.update_all is_exported_to_access_db: true
  end

end
