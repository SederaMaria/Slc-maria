class NotifyDealershipLicenseExpirationService

  def notify
    today = Date.today
    after_thirty_days = today + 30.days
    expired_dealerships = Dealership.where(license_expiration_date: after_thirty_days)
    recipients = ENV.fetch('DEALERSHIP_EXPIRATION_EMAIL_RECIPIENTS')
    cc_recipients = ENV.fetch('DEALERSHIP_EXPIRATION_EMAIL_CC_RECIPIENTS')
    if expired_dealerships.present?
      DealershipMailer.notify_dealership_expirations(recipients, cc_recipients, expired_dealerships).deliver_now
    elsif today.day == 1
      DealershipMailer.notify_dealership_not_expires(recipients, cc_recipients).deliver_now
    end
  end
end
