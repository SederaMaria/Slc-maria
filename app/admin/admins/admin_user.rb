ActiveAdmin.register AdminUser, namespace: :admins do
  menu parent: "Administration", url: "#{ENV['LOS_UI_URL']}/administration/admin-users",  if: proc{ current_admin_user.is_administrator? }
  actions :all, except: [:destroy]

  after_create do |admin_user|
    SendAdminWelcomeEmail.call(recipient: admin_user)
  end

  member_action :toggle_disabled, method: :put do
    resource.toggle! :is_active
    message = if resource.is_active?
                "Account #{resource.email} successfully enabled"
              else
                "Account #{resource.email} successfully disabled"
              end
    redirect_back fallback_location: admins_root_path, notice: message 
  end
  
  member_action :unlock, method: :put do
    message = "Unlock instruction sent to #{resource.email}"
    resource.send_unlock_instructions
    redirect_back fallback_location: admins_root_path, notice: message 
  end
  
  member_action :reset_password do
    admin_user = AdminUser.find(params[:id])
    admin_user.send_reset_password_instructions
    redirect_to(admins_admin_user_path(admin_user),
    notice: "Password reset email sent to #{admin_user.email}")
  end

  
  controller do
    def permitted_params
      params.permit!
    end
  end
    
  index do
    selectable_column
    id_column
    column :first_name 
    column :last_name 
    column :email
    column :sign_in_count
    column 'Last Sign In' do |user|
      user.current_sign_in_at
    end
    column :created_at
    column 'Is Locked' do |user|
      button_to 'Unlock',  unlock_admins_admin_user_path(user), method: :put, class: 'button', :disabled => !user.access_locked?, :style => "#{user.access_locked? ? '' : 'opacity: 0.5;' }"
    end
    column :is_active do |user|
      link_to user.is_active.to_s.upcase, toggle_disabled_admins_admin_user_path(user), method: :put, class: 'button', data: { confirm: "Are you sure? This will disable the Admin User account #{user.email}" }
    end

    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  # form do |f|
  #   f.inputs "Admin Details" do
  #     f.input :first_name
  #     f.input :last_name
  #     f.input :email
  #     f.input :job_title
  #   end 
  #   f.actions
  # end

  form partial: 'form'

  show do |admin|
    attributes_table do
      row :id 
      row :first_name 
      row :last_name 
      row :email 
      row :encrypted_password 
      row :reset_password_token 
      row :reset_password_sent_at 
      row :remember_created_at 
      row :sign_in_count 
      row :current_sign_in_at 
      row :last_sign_in_at 
      row :current_sign_in_ip 
      row :last_sign_in_ip 
      row :created_at 
      row :updated_at 
      row :password_changed_at 
      row :failed_attempts 
      row :unlock_token 
      row :locked_at 
      row :is_active
    end

    div do
      panel("Audits") do
        table_for(Admins::AuditDecorator.wrap(admin.retrieve_audits)) do
          column :created_at
          column 'Admin User', :audited
          column 'By Who', :user
          column 'Changes', :audited_changes
        end
      end
    end
    active_admin_comments
  end



end
