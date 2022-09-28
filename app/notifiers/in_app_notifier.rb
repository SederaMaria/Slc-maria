require 'render_anywhere'

class InAppNotifier
	include RenderAnywhere

	def initialize(notification:)
		@notification = notification
	end

	def validate
		responds_to_desired_message
	end

	def application_submitted
		broadcast_on_recipient_channel
		broadcast_on_notifiable_scoped_channel
	end

	def bike_change
		broadcast_on_recipient_channel
		broadcast_on_notifiable_scoped_channel
	end

	def lease_documents_requested
		broadcast_on_recipient_channel
		broadcast_on_notifiable_scoped_channel
	end

	def colessee_added
		broadcast_on_recipient_channel
		broadcast_on_notifiable_scoped_channel
	end

	def reference_added
		broadcast_on_recipient_channel
		broadcast_on_notifiable_scoped_channel
	end

	def lease_attachment_added
		broadcast_on_recipient_channel
		broadcast_on_notifiable_scoped_channel
	end

	def colessee_removed
		broadcast_on_recipient_channel
		broadcast_on_notifiable_scoped_channel
	end

	private
		attr_reader :notification

		def broadcast_on_notifiable_scoped_channel
			NotificationsChannel.broadcast_to(
				notifiable_scoped_channel,
				{
					template: html_template
				}
			)
		end

		def broadcast_on_recipient_channel
			NotificationsChannel.broadcast_to(
				notification.recipient.broadcast_channel,
				{
					template: html_template
				}
			)
		end

		def responds_to_desired_message
			unless self.respond_to? notification.notification_content
				notification.errors.add(:notification_content, "#{notification.notification_content} notification is not implemented")
			end
		end

		def html_template
			# render partial: "notifications/#{notification.notification_content}",
			#        locals:  {
			# 	       notification: notification,
			# 	   }
			ActionController::Base.new.render_to_string(partial: "notifications/#{notification.notification_content}", locals: { notification: notification })
		end

		def notifiable_scoped_channel
			"#{recipient_broadcast_channel}:#{notification.notifiable_type.underscore}:#{notifiable.id}"
		end

		def recipient_broadcast_channel
			notification.recipient.broadcast_channel
		end

		def notifiable
			notification.notifiable
		end
end
