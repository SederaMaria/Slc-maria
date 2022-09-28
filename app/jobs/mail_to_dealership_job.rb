class MailToDealershipJob < ApplicationJob
  queue_as :default

  def perform(attachment_id)
    attachment = LeaseApplicationAttachment.find(attachment_id)
    dealership = attachment.lease_application.dealership
    dealers = dealership.active_dealers

    dealers.each do |dealer|
      DealerMailer.attachment_distribution(attachment: attachment, dealer: dealer).deliver_now
    end
  end
end
