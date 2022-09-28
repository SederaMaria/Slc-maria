class LeasepakMailer < ApplicationMailer
  include MailerHelper
  after_action :mail_logger
  
  def status_transfer_failure(app_id)
    @app_id = app_id
    mail(to: ENV['EXCEPTION_RECIPIENTS'],
         subject: "Bridging API EC2 Instance Unreachable, Failed call for : #{app_id}")
  end


  def failure_email(app_id, errors, type)
    @app_id = app_id
    @errors = errors
    @type = type
    @mailTemplate = 'status_transfer_failure'
    mail(to: ENV['EXCEPTION_RECIPIENTS'], 
         subject: "Leasepak returned error for Lease Application - #{app_id}") do | format |
          format.html { render @mailTemplate }
    end
  end

  def datax_job_failure_email(datax_id)
    @datax = LeaseApplicationBlackboxRequest.find(datax_id)
    @lease_application = @datax.lease_application
    @mailTemplate = 'datax_job_failure'
    @subject = "Datax Sent REJECT for Lease Application - #{@lease_application.application_identifier}"
    mail(to: ENV['EXCEPTION_RECIPIENTS'], 
         subject: @subject) do | format |
          format.html { render @mailTemplate }
    end
    Rails.logger.info("Emailing datax failure notification to #{ENV['EXCEPTION_RECIPIENTS']} with subject #{@subject}")
  end
end