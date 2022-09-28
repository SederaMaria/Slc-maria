class Api::V1::NotificationsController < Api::V1::ApiController

  DEFAULT_PAGE = 1
  PER_PAGE = 25
  
  def index
    notifications = []
    find_notifications
    @notifications.each do |notification|
      notifications << notification.attributes.merge!({
        notification_content: notification.notification_text,
        url: notification.redirect_url })
    end
    render :json => {notifications: notifications}
  end

  def mark_as_read
    current_user.notifications.find(params[:id]).mark_as_read
    render json: {
      message: 'Update successfully',
      status: 200
    }
  end

  def mark_all_read
    if lease_application
      notifications = current_user.notifications.unread.where(notifiable: lease_application)
    else
      notifications = current_user.notifications.unread
    end
    notifications.update_all(read_at: Time.now)
    render json: {
      message: 'Update successfully',
      status: 200
    }
  end

  def get_all_notifications
    result = {}
    unread_page = (params[:unread_page] || DEFAULT_PAGE).to_i
    read_page = (params[:read_page] || DEFAULT_PAGE).to_i

    unread_notifications = []
    notifications = current_user.notifications.in_app.unread.order(created_at: :desc).page(unread_page)
    notifications_size = notifications.size
    index_start = unread_page.zero? ? 0 : ((unread_page - 1) * PER_PAGE) + 1
    last_index = (index_start + notifications_size).zero? ? 0 : (index_start + notifications_size - 1)
    notifications.each do |notification|
       unread_notifications << notification.attributes.merge!({
        notification_content: notification.notification_text })
    end
    result[:unread] = {
      entries: unread_notifications,
      pagination: {
        unread_page: unread_page,
        total_pages: notifications.total_pages,
        total_count: notifications.total_count,
        per_page: notifications_size,
        start_index: index_start,
        last_index: last_index
      }
    }

    read_notifications = []
    notifications = current_user.notifications.in_app.read.order(created_at: :desc).page(read_page)
    notifications_size = notifications.size
    index_start = read_page.zero? ? 0 : ((read_page - 1) * PER_PAGE) + 1
    last_index = (index_start + notifications_size).zero? ? 0 : (index_start + notifications_size - 1)
    notifications.each do |notification|
       read_notifications << notification.attributes.merge!({
        notification_content: notification.notification_text })
    end
    result[:read] = {
      entries: read_notifications,
      pagination: {
        read_page: read_page,
        total_pages: notifications.total_pages,
        total_count: notifications.total_count,
        per_page: notifications_size,
        start_index: index_start,
        last_index: last_index
      }
    }
    render json: result
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
end