class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from scoped_channel
  end

  def unsubscribed
    stop_all_streams
  end

  def scoped_channel
    str  = "notifications"
    str += ":"
    str += current_user.broadcast_channel
    str += notifiable_scope
    return str
  end

  def notifiable_scope
    return '' unless params[:referer]
    record = LeaseApplication.find_by_url(params[:referer])
    if record
      return ":#{record.class.to_s.underscore}:#{record.id}"
    else
      return ''
    end
  end
end
