class CreditDecisionNotificationMailer < ApplicationMailer
  include MailerHelper
  after_action :mail_logger
  
  def approved(application:, dealer:, files: {})
    @application = application
    @dealer      = dealer
    subject = "Approval for #{@application.application_identifier} #{@application.lessee.full_name&.upcase}"
    subject += " & #{@application.colessee.full_name&.upcase}" if @application.colessee
    add_attachments(files) unless files.empty?
    mail(to: dealer.email,
         subject: subject)
  end

  def approved_with_contingencies(application:, dealer:, files: {})
    @application = application
    @dealer      = dealer
    subject = "Approval with Contingencies for #{@application.application_identifier} #{@application.lessee.full_name&.upcase}"
    subject += " & #{@application.colessee.full_name&.upcase}" if @application.colessee
    add_attachments(files) unless files.empty?
    mail(to: dealer.email,
         subject: subject)
  end

  def requires_additional_information(application:, dealer:, files: {})
    @application = application
    @dealer      = dealer
    subject = "Additional Information Required for #{@application.application_identifier} #{@application.lessee.full_name&.upcase}"
    subject += " & #{@application.colessee.full_name&.upcase}" if @application.colessee
    add_attachments(files) unless files.empty?
    mail(to: dealer.email,
         subject: subject)
  end

  def declined(application:, dealer:, files: {})
    @application = application
    @dealer      = dealer
    subject = "Declination for #{@application.application_identifier} #{@application.lessee.full_name&.upcase}"
    subject += " & #{@application.colessee.full_name&.upcase}" if @application.colessee
    add_attachments(files) unless files.empty?
    mail(to: dealer.email,
         subject: subject)
  end

  def rescinded(application:, dealer:, files: {})
    @application = application
    @dealer      = dealer
    subject = "Rescinded - #{@application.application_identifier} #{@application.lessee.full_name&.upcase}"
    subject += " & #{@application.colessee.full_name&.upcase}" if @application.colessee
    add_attachments(files) unless files.empty?
    mail(to: dealer.email,
         subject: subject)
  end

  def withdrawn(application:, dealer:, files: {})
    @application = application
    @dealer      = dealer
    subject = "Withdrawn - #{@application.application_identifier} #{@application.lessee.full_name&.upcase}"
    subject += " & #{@application.colessee.full_name&.upcase}" if @application.colessee
    add_attachments(files) unless files.empty?
    mail(to: dealer.email,
         subject: subject)
  end
  
  def unsubmitted(application:, dealer:, files: {})
    @application = application
    @dealer      = dealer
    subject = "Unsubmitted - #{@application.application_identifier} #{@application.lessee.full_name&.upcase}"
    subject += " & #{@application.colessee.full_name&.upcase}" if @application.colessee
    add_attachments(files) unless files.empty?
    mail(to: dealer.email,
         subject: subject)
  end

  def add_attachments(files)
    files.each do |filename, path|
      attachments[filename] = File.open(path).read
    end
  end
end