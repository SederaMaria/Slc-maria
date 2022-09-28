class AdminMailer < ApplicationMailer
	include MailerHelper
	after_action :mail_logger
	
	def welcome_email(recipient:, reset_password_token:)
	    @recipient            = recipient
	    @reset_password_token = reset_password_token
	    mail(to:      recipient.email,
	         subject: "Welcome to the LOS")
	end
	def models_list(new_models, updated_models)
		@new_models = new_models
		@updated_models = updated_models
		mail(to: ENV['NADA_EMAIL_RECIPIENTS'],
         subject: "NADA Data Pull Updates -  #{Date.today}")
	end

	def test_mailer(urls, from_date, to_date)
		@urls = urls
		mail(to: 'rprasad@speedleasing.com',
         subject: "LeaseApplicationAttachment URLS for #{from_date} - #{to_date}")
	end

	def notification_for_invalid_pdf_template(invalid_template_urls, valid_template_urls)
		@temp_url = invalid_template_urls
		@valid_urls = valid_template_urls

		mail(to: ENV['NADA_EMAIL_RECIPIENTS'],
	      subject: "PDF Template Error - Request for reupload pdf template")
	end
	
end