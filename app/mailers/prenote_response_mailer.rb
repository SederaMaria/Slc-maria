class PrenoteResponseMailer < ApplicationMailer
	include MailerHelper
	after_action :mail_logger
	
	def prenote_response(email:, prenote:)
      @prenote              = prenote
      @application          = prenote.lease_application
	    mail(to:      email,
	         subject: "#{prenote.lease_application.application_identifier} #{prenote&.lease_application&.lessee.first_name} #{prenote&.lease_application&.lessee.last_name} Prenote Status")
	end
  
end