ActiveAdmin.register LeaseApplicationWelcomeCall, namespace: :admins do
  menu parent: 'Lease Application Related'
  actions :show, :index

  index do
    id_column
    column :lease_application
    column 'Welcome Call Result' do |call|
      call.welcome_call_result&.description
    end
    column 'Welcome Call Type' do |call|
      call.welcome_call_type&.description
    end
    column 'Welcome Call Status' do |call|
      call.welcome_call_status&.description
    end
    column 'Admin User' do |call|
      call.admin_user&.full_name
    end
    column 'Due Date' do |call|
      call&.lease_application&.welcome_call_due_date&.strftime('%B %d, %Y')
    end
    column :notes
    column :created_at
    column :updated_at
    column 'Actions' do |resource|
      link_to 'View', [:admins, resource]
    end
  end

  filter :lease_application, as: :select, collection: proc { LeaseApplication.where("document_status IN (?)", ["funded", "funding_approved"]).pluck(:application_identifier, :id) }
  filter :welcome_call_type, as: :select, collection: proc { WelcomeCallType.order(:description).pluck(:description, :id) }
  filter :welcome_call_result, as: :select, collection: proc { WelcomeCallResult.order(:description).pluck(:description, :id) }
  filter :welcome_call_status, as: :select, collection: proc { WelcomeCallStatus.order(:description).pluck(:description, :id) }
  filter :admin_user, as: :select, collection: proc { AdminUser.get_active_admin_users }
  filter :due_date
  filter :notes
  filter :created_at
  filter :updated_at

  show do |calls|
    attributes_table do
      row 'Due Date' do |object|
        object&.lease_application&.welcome_call_due_date&.strftime('%B %d, %Y')
      end
      row 'Status' do |object|
        object&.welcome_call_result&.description
      end
      row 'Date and Time' do |object|
        object&.created_at.strftime('%e %b %Y %H:%M:%S%p')
      end
      row 'Representative' do |object|
        object&.admin_user&.email
      end
      row 'Type' do |object|
        object&.welcome_call_type&.description
      end
      row 'Result' do |object|
        object&.welcome_call_result&.description
      end
      row :notes
    end
    active_admin_comments
  end
  
end
