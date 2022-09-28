ActiveAdmin.register Notification, namespace: :admins do
  menu false
  actions :show, :index

  member_action(:resend, method: :put) do
    resource.resend
    redirect_back(fallback_location: admins_root_path, **{ notice: 'This attachment will now be resent.' })
  end

  controller do
    def scoped_collection
      super.includes(:recipient, :notifiable).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end

  # filter :dealership_name, as: :select, collection: proc { Dealership.order(:name).pluck('DISTINCT name') }
  filter :recipient_of_AdminUser_type_email_eq, as: :select, collection: proc { AdminUser.pluck(:email) }, label: 'By Admin'
  filter :recipient_of_Dealer_type_email_eq, as: :select, collection: proc { Dealer.pluck(:email) }, label: 'By Dealer'
  filter :notification_mode, as: :select, collection: proc { Notification.pluck('DISTINCT notification_mode') }
  filter :notification_content, as: :select, collection: proc { Notification.pluck('DISTINCT notification_content') }
  filter :created_at, label: 'First Sent At'
  filter :updated_at, label: 'Latest Sent At'

  index do
    id_column
    column :recipient do |notification|
      notification.recipient.try(:email)
    end
    column :notifiable
    column :notification_mode
    column :notification_content do |n|
      n.notification_content.humanize
    end
    column :read_at do |n|
      n.read_at ? n.read_at : 'Unread / NA'
    end
    column(:first_sent_at) do |n|
      n.created_at
    end
    column :last_sent_at do |n|
      n.updated_at
    end
    actions
  end

  show do |n|
    attributes_table do
      row :id
      row :read_at
      row :recipient
      row :recipient_type
      row :notification_mode
      row :notification_content
      row :notifiable
    end
    panel("Attachments") do
      table_for(resource.notification_attachments) do
        column :id
        column :description
        column :file do |a|
          link_to 'Download', a.upload.url, target: '_blank'
        end
        column :sent_at do |a|
          a.created_at
        end
      end
    end
  end
end