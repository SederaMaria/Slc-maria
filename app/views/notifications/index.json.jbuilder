json.array! @notifications do |notification|
  #Where is notification_content ?!?!?!?!?
  json.id notification.id
  json.read
  json.unread !notification.read_at?
  json.template render partial: "notifications/#{notification.notification_content}", locals: { notification: notification }, formats: [:html]
  json.data notification.data
end
