class ExpireLeaseApplicationService

  def expire!
    LeaseApplication.expireable_applications.update_all(expired: true)
  end
end
