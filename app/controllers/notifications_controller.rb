class NotificationsController < ApplicationController
  def index
    find_notifications
  end

  def mark_as_read
    current_user.notifications.find(params[:id]).mark_as_read
  end

  def mark_all_read
    if lease_application
      notifications = current_user.notifications.unread.where(notifiable: lease_application)
    else
      notifications = current_user.notifications.unread
    end
    notifications.update_all(read_at: Time.now)

    respond_to do |format|
      format.html { redirect_to admins_all_notifications_url }
    end
  end

private
  def find_notifications
    return nil unless current_user
    if lease_application
      @notifications  = current_user.notifications.in_app.where(notifiable: lease_application).unread.order(created_at: :desc).limit(25)
      @notifications += current_user.notifications.in_app.where(notifiable: lease_application).read.order(created_at: :desc).limit(10)
    else
      @notifications  = current_user.notifications.in_app.unread.order(created_at: :desc).limit(25)
      @notifications += current_user.notifications.in_app.read.order(created_at: :desc).limit(10)
    end
  end

  def lease_application
    LeaseApplication.find_by_url(request.referer)
  end

  def current_user
    current_admin_user || current_dealer
  end
end
