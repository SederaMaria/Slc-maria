ActiveAdmin.register_page "All Notifications", namespace: :admins do
  menu false

  action_item 'Mark all Read' do
    link_to "Mark all Read", mark_all_read_notifications_path, method: :post
  end

  content do
    panel 'Unread Notifications' do
      unread_notifications  = current_admin_user.notifications.in_app.unread.order(created_at: :desc)
      paginated_collection(unread_notifications.page(params[:unread_page]), download_links: false, param_name: 'unread_page') do
        table_for(collection, sortable: false) do
          column do |notification|
            render partial: "notifications/#{notification.notification_content}", locals: { notification: notification }, formats: [:html]
          end
        end
      end
    end

    panel 'Read Notifications' do
      read_notifications  = current_admin_user.notifications.in_app.read.order(created_at: :desc)
      paginated_collection(read_notifications.page(params[:read_page]), download_links: false, param_name: 'read_page') do
        table_for(collection, sortable: false) do
          column do |notification|
            render partial: "notifications/#{notification.notification_content}", locals: { notification: notification }, formats: [:html]
          end
        end
      end
    end
  end
end