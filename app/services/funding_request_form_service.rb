require 'fileutils'
require 'money'

class FundingRequestFormService
  
  def initialize(lease_id:, is_revised:)
    @lease_application = LeaseApplication.find_by(id: lease_id)
    @is_revised = is_revised
  end

  def call
    prefilled_doc_path
    send_email_to_recipients
    if create_funding_request_history
      delete_file
    end
  end

  attr_reader :lease_application, :filepath
  
  private

  def prefilled_doc_path
    FileUtils::mkdir_p(File.join(Rails.root, 'tmp', 'funding_request_form'))
    source_doc_path = CommonApplicationSetting.instance.funding_request_form_path
    dest_doc_path   = File.join(Rails.root, 'tmp', 'funding_request_form', "#{lease_application.application_identifier}_funding_request_#{Time.now.to_i}.pdf")
    pdftk.fill_form source_doc_path, dest_doc_path, fields, flatten: true
    @filepath = dest_doc_path
  end

  def send_email_to_recipients
    subject = 'Funding Request Form:'
    subject = 'REVISED FUNDING REQUEST:' if @is_revised
    email_list.each do |recipient|
      DealerMailer.send_funding_request_form(recipient: recipient, filepath: filepath, app: @lease_application, subject: subject).deliver
    end
  end

  def email_list
    ENV['FUNDING_APPROVAL_RECIPIENTS'].split(",")
  end

  def pdftk
    @pdftk ||= PdfForms.new(pdftk_path)
  end

  def pdftk_path
    PdftkConfig.executable_path
  end

  def fields
    lessee = lease_application.lessee
    dealership = lessee.dealership
    lease_calculator = lease_application.lease_calculator
    {
      "Date" => Date.today.strftime("%m/%d/%Y"),
      "Date Requested" =>  Date.today.strftime("%m/%d/%Y"),
      "Lesee Name" => "#{lessee.last_name}, #{lessee.first_name}",
      "Lease Number" => lease_application.application_identifier,
      "Dealership" => dealership.name,
      "Routing Number" => dealership.routing_number,
      "Account Number" => dealership.account_number,
      "Bank" => dealership.bank_name,
      "Name on Account" => dealership.name,
      "Address on Account" => dealership.address.full_name,
      "Gross Amount" => Money.new(lease_calculator.remit_to_dealer_cents, 'USD').format,
      "Requested By" => lease_application.requester&.full_name,
      "Approved By" => lease_application.approver&.full_name,
      "Less Shortfund" => Money.new(lease_calculator.dealer_shortfund_amount, 'USD').format,
      "Remit to Dealer" => Money.new(lease_calculator.remit_to_dealer_less_shortfund, 'USD').format
     }
  end

  def delete_file
    File.delete(filepath) if File.exist?(filepath)
  end

  def create_funding_request_history
    lease_application.lease_application_attachments.create({
      upload: File.open(filepath),
      visible_to_dealers: false,
      description: "Funding Request Form"
    })
  end
  
  
end