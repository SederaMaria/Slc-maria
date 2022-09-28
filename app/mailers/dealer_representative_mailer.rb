class DealerRepresentativeMailer < ApplicationMailer
	include MailerHelper
	after_action :mail_logger
	
	def welcome_call_request(recipient:, application:)
      @application          = application
	    @recipient            = recipient
	    mail(to:      recipient.email,
					 cc: 		ENV['SALES_EMAIL'],
	         subject: "Request Verification Call for Funding")
	end
  
end