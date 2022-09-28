class DealerMailer < ApplicationMailer
  include MailerHelper
  after_action :mail_logger
  
  def welcome_email(recipient:, reset_password_token:)
    @recipient            = recipient
    @reset_password_token = reset_password_token
    mail(to:      recipient.email,
         subject: "Action Required: Your account has been created")
  end

  def application_submitted(application_id:)
    @application    = LeaseApplication.find(application_id)
    @dealer         = @application.dealer
    dealership_name = @application.dealership.name
    @lease_details  = @application.lease_calculator
    @lessee         = @application.lessee
    @colessee       = @application.colessee
    mail(to: merge(ENV['SUPPORT_EMAIL'], ENV['DEALER_MAILER_CREDIT_EVENT_EMAIL']),
         subject: "New Application from #{dealership_name}")
  end

  def application_submitted_dealer(application_id:)
    @application        = LeaseApplication.find(application_id)
    @dealer             = @application.dealer
    dealership_name     = @application.dealership.name
    @lease_details      = @application.lease_calculator
    @lessee             = @application.lessee
    @colessee           = @application.colessee
    notification_email  = @application.dealership.notification_email
    if notification_email
      mail(to: notification_email,
           subject: "New Application from #{dealership_name}")
    end
  end

  def documents_requested(application_id:, lease_request_id:)
    @application    = LeaseApplication.find(application_id)
    @dealer         = @application.dealer
    @dealership     = @application.dealership
    @lease_details  = @application.lease_calculator
    @lease_request  = @application.lease_document_requests.find(lease_request_id)
    @vin_validation = @lease_request&.vin_validation
    @lessee         = @application.lessee
    @colessee       = @application.colessee
    mail(to: ENV['SUPPORT_EMAIL'],
         subject: "Lease Document Request for #{@application.application_identifier}")
  end

  def bike_change_submitted(application_id, original_bike, original_bike_nada_retail)
    @application               = LeaseApplication.find(application_id)
    @dealer                    = @application.dealer
    @lease_details             = @application.lease_calculator
    @lessee                    = @application.lessee
    @colessee                  = @application.colessee
    @original_bike             = original_bike
    @original_bike_nada_retail = original_bike_nada_retail
    mail(to: merge(ENV['SUPPORT_EMAIL'], ENV['DEALER_MAILER_CREDIT_EVENT_EMAIL']),
         subject: "Bike Change Submitted for #{@application.application_identifier}")
  end

  def file_attachment_notification(attachment_id:)
    @attachment    = LeaseApplicationAttachment.find(attachment_id)
    @application   = @attachment.lease_application
    @dealer        = @application.dealer
    @lease_details = @application.lease_calculator
    @lessee        = @application.lessee
    @colessee      = @application.colessee

    recipients = [ENV['SUPPORT_EMAIL']]
    [
      :documents_issued,
      :lease_package_received,
      :funding_delay,
      :funding_approved,
      :funded,
    ].include?(@application.document_status.to_sym) ? recipients.push(ENV['FUNDING_EMAIL']) : nil

    mail(to: merge(recipients, ENV['DEALER_MAILER_CREDIT_EVENT_EMAIL']),
         subject: "Stipulation Attachment added to #{@application.application_identifier}")
  end

  def dealer_added_colessee(application:)
    @application   = application
    @lease_details = @application.lease_calculator
    @dealer        = @application.dealer
    @lessee        = @application.lessee
    @colessee      = @application.colessee
    mail(to: merge(ENV['SUPPORT_EMAIL'], ENV['DEALER_MAILER_CREDIT_EVENT_EMAIL']),
         subject: "Colessee added to #{@application.application_identifier}")
  end

  def dealer_removed_colessee(application:, colessee:)
    @application   = application
    @lease_details = @application.lease_calculator
    @dealer        = @application.dealer
    @lessee        = @application.lessee
    @colessee      = colessee #must be passed in because this record should have been destroyed
    mail(to: merge(ENV['SUPPORT_EMAIL'], ENV['DEALER_MAILER_CREDIT_EVENT_EMAIL']),
         subject: "Colessee Removed from #{@application.application_identifier}")
  end

  def attachment_distribution(attachment:, dealer:)
    @application = attachment.lease_application
    @attachment  = attachment
    @dealer      = dealer
    mail(to: dealer.email,
         subject: "Attachment received for #{@application.application_identifier}")
  end

  def dealer_notification(application:, dealer:, status:)
    @application = application    
    recipient = dealer.email
    @subject = " #{application.application_identifier} #{application.lessee.name.titleize}"
    @status = status
    @statusFriendly = status.gsub('_', ' ').split.map(&:capitalize)*' '
    
    case status
    when 'lease_package_received'
      attachments.inline["funding_package_received.png"] = File.read("#{Rails.root}/app/assets/images/funding_package_received.png")
      @mailTemplate = 'funding_package_received'
      @subject.insert(0,'Funding Package Received -')
    when 'funding_delay','remaining_funding_delay'
      attachments.inline["funding_delay.jpg"] = File.read("#{Rails.root}/app/assets/images/funding_delay.jpg")
      @mailTemplate = 'funding_delay'
      @reasons = application.funding_delays.all
      @reasons.select{|r| r.status == 'Required'} if status == 'remaining_funding_delay'
      @subject.insert(0,'Funding Delayed -')
    when 'funding_approved'
      attachments.inline["funding_approved.jpg"] = File.read("#{Rails.root}/app/assets/images/funding_approved.jpg")
      @mailTemplate = 'funding_approved'
      @subject.insert(0,'Funding Approved -')
    when 'funded'
      attachments.inline["funded_notification.png"] = File.read("#{Rails.root}/app/assets/images/funded_notification.png")    
      @funded_amount = application.lease_calculator&.remit_to_dealer&.to_f - application.this_deal_dealership_clawback_amount.to_i
      @mailTemplate = 'lease_funded'
      @subject.insert(0,'Lease Funded -')
    end
    
    mail(to: recipient, 
        from: ENV['FUNDING_EMAIL'],
        subject: @subject) do | format |
          format.html { render @mailTemplate }
    end
    
    Rails.logger.info("Emailing #{@statusFriendly} dealer notification to #{recipient} with subject #{@subject}")
  end

  def reference_added(application:, reference:)
    @application = application
    @reference   = reference
    mail(to: ENV['SUPPORT_EMAIL'],
         subject: "New reference added for #{@application.application_identifier}")
  end

  def lease_applications_export(recipient:, filepaths:)
    filepaths.each_with_index do |filepath, i|
      attachments["lease_applications_export#{i + 1}.csv"] = File.read(filepath)
    end
    mail(to: recipient,
         subject: "Your Lease Applications CSV export is ready")
  end
  
  def model_years_export(recipient:, filepath:)
    attachments["model_years_export.csv"] = File.read(filepath)
    mail(to: recipient,
         subject: "Your Model Year CSV export is ready")
  end

  def tax_jurisdictions_export(recipient:, filepath:)
    attachments['tax_jurisdiction.csv'] = File.read(filepath)
    mail(to: recipient,
         subject: "Your Tax Jurisdictions CSV export is ready")
  end

  def access_db_export(recipient:, filepath:)
    attachments['access_db_export.zip'] = File.read(filepath)
    mail(to: recipient,
         subject: "Your Access DB Export is ready")
  end

  def funding_delay_export(recipient:, filepath:)
    attachments["funding_delay_export.csv"] = File.read(filepath)
    mail(to: recipient,
         subject: "Your Funding Delay export is ready")
  end

  def poa_pdf_export(recipient:, filepath:)
    attachments["#{filepath.path}"] = {
      mime_type: 'application/pdf',
      content: open(filepath).read
    }
    mail(
      to:      recipient, 
      subject: 'Power of Attroney Export is ready'
      )
  end

  def send_funding_request_form(recipient:, filepath:, app:, subject:)
    attachments["funding_request_form.pdf"] = {
      mime_type: 'application/pdf',
      content: open(filepath).read
    }
    mail(
      to:      recipient, 
      subject: "#{subject} #{app.application_identifier} #{app.lessee&.full_name} (#{app&.dealership&.name})"
      )
  end

  private

  def merge(*envs)
    envs.compact.join(",")
  end
end
