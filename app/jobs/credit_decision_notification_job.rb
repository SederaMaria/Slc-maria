require 'pdf-reader'
class CreditDecisionNotificationJob
  include Sidekiq::Worker

  sidekiq_options unique:      :until_executed,
                  unique_args: :unique_args

  def self.unique_args(args)
    # notification = Notification.find(args[0]['notification_id'])
    # [notification.notification_content, notification.recipient.email]
    "#{args[0]['notification_content']}_#{args[0]['recipient_email']}"
  end

  def perform(opts)
    opts.symbolize_keys!
    @notification = Notification.find(opts[:notification_id])
    @app          = notification.notifiable
    @recipient    = notification.recipient
    @attachments  = {}
    
    load_attachments
    send_notification
    store_attachments
  end

  private
  attr_reader :app, :recipient, :attachments, :notification

  def log(msg)
    Rails.logger.info(" [#{Time.now.utc.strftime('%B %-d %Y at %r %Z')}][#{@recipient.email}] - CreditDecisionNotificationJob: #{msg}")
  end

  def load_attachments
    if %w(approved approved_with_contingencies declined).include? app.credit_status
      attach_risk_based_pricing_letters
      log("Attached risk based pricing letters")
    end
    if %w(requires_additional_information approved approved_with_contingencies declined).include? app.credit_status
      attach_credit_decision_form
      log("Attached credit decision form")
    end
  end

  def attach_risk_based_pricing_letters
    begin
      unless app.lessee&.last_successful_credit_report.blank?
        attachments[risk_based_pricing_filename(app.lessee)]   = risk_based_pricing_letter(app.lessee) if is_has_credit_score_disclosure(app.lessee)
      end

      unless app.colessee&.last_successful_credit_report.blank?
        attachments[risk_based_pricing_filename(app.colessee)]   = risk_based_pricing_letter(app.colessee) if is_has_credit_score_disclosure(app.colessee)
      end
    rescue => e
      log("Adding risk based pricing letter for application mail #{app.id} failed: #{e}")
    end
  end

  def risk_based_pricing_filename(lessee)
    "Risk Based Pricing - #{app&.application_identifier} - #{lessee&.first_name&.upcase} #{lessee&.last_name&.upcase}.pdf"
  end

  def attach_credit_decision_form
    begin
      attachments[credit_decision_form_filename] = credit_decision_form
    rescue => e
      log("Adding credit decision form for application mail #{app.id} failed: #{e}")
    end
  end

  def send_notification
    unless app.credit_status == 'awaiting_credit_decision'
      CreditDecisionNotificationMailer.public_send(app.credit_status.to_sym, application: app, dealer: recipient, files: attachments).deliver_now
    end
  end

  def store_attachments
    attachments.each do |filename, filepath|
      notification.notification_attachments.create(
        description: filename, 
        upload:      File.open(filepath)
      )
    end
    log("Store Attachments")
  end

  def credit_decision_form_filename
    status               = app.credit_status.humanize.split.map { |i| i.capitalize }.join(' ')
    app_id               = app.application_identifier
    lessee_name          = app.lessee.name.upcase
    extension            = '.pdf'
    joined_colessee_name = if !app.colessee.blank?
                             " and #{app.colessee.name.upcase}"
                           else
                             ''
                           end
    "#{status} for #{app_id} #{lessee_name}#{joined_colessee_name}#{extension}"
  end

  def risk_based_pricing_letter(lessee)
    PdftkClient.new(
      source_file: local_credit_report_path(lessee)
    ).extract_risk_based_pricing_letter
  end

  def credit_decision_form
    CreditDecisionAttachment.new(lease_application: app, dealer: app.dealer).prefilled
  end

  def local_credit_report_path(lessee)
    report   = lessee.last_successful_credit_report
    download = open(report.upload.url)
    filename = report.upload.file.filename
    filepath = "#{Rails.root}/tmp/#{filename}"
    IO.copy_stream(download, filepath)
    return filepath
  end

  def is_has_credit_score_disclosure(lessee)
    reader = PDF::Reader.new(local_credit_report_path(lessee))
    res = false
    reader.pages.each do |page|
      if page.text.include?("Credit Score Disclosure")
        res = true
        break 
      end
    end
    res
  end


end