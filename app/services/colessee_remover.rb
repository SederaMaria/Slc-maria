class ColesseeRemover < SimpleDelegator
  
  def remove_colessee!
    raise("This class only decorates LeaseApplications") unless __getobj__.is_a?(LeaseApplication)
    return false unless can_remove_colessee?
    
    colessee_to_destroy = colessee
    attributes_for_update = {colessee_id: nil}
    attributes_for_update[:credit_status]= "awaiting_credit_decision" if submitted?
    
    LeaseApplication.transaction do        
      #nullify CoLessee Association, reset Credit Status if the application has been submitted.
      update(attributes_for_update)

      #Mark Lessee Record as a destroyed record.  Makes it accessible from its original Lease application.
      colessee_to_destroy.update(deleted_from_lease_application_id: id, deleted_at: DateTime.now)
    end
    
    if deleted_colessees.where(id: colessee_to_destroy.id).exists?
      #its ok to deliver this in the web transaction, we need it to go out very quickly
      notify_admins(colessee_to_destroy)
    end
  end

  def can_remove_colessee?
    colessee_id.present?
  end

  private
    def notify_admins(colessee_to_destroy)
      DealerMailer.dealer_removed_colessee(application: __getobj__, colessee: colessee_to_destroy).deliver_now
      Notification.create_for_admins(
        notification_mode: 'InApp',
        notification_content: 'colessee_removed',
        notifiable: __getobj__
      )
    end
end
