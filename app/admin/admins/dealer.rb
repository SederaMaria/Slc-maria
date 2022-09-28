ActiveAdmin.register Dealer, namespace: :admins do
  menu parent: 'Dealer Related', label: 'Dealer Users'
  actions :all, except: [:destroy]

  before_create do |dealer|
    dealer.skip_password_validation = true
  end

  after_create do |dealer|
    SendWelcomeEmail.call(recipient: dealer)
  end

  member_action :toggle_disabled, method: :put do
    resource.toggle! :is_disabled
    message = if resource.is_disabled?
                "Account #{resource.email} successfully disabled"
              else
                "Account #{resource.email} successfully enabled"
              end
    redirect_back fallback_location: admins_root_path, notice: message 
  end

  controller do
    def scoped_collection
      super.includes(:dealership).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end
  
  index title: 'Dealer Users' do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :dealership
    column :sign_in_count
    column :first_sign_in_at
    column :last_sign_in_at
    column :is_disabled do |dealer|
      link_to dealer.is_disabled.to_s.upcase, toggle_disabled_admins_dealer_path(dealer), method: :put, class: 'button', data: { confirm: "Are you sure? This will disable the Dealer account #{dealer.email}" }
    end
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :dealership, as: :select, collection: proc { Dealership.order(:name) }
  filter :by_dealer_representative, :as => :select, collection: proc { DealerRepresentative.joins("JOIN admin_users as au ON dealer_representatives.email = au.email ORDER BY dealer_representatives.first_name, dealer_representatives.last_name").map{|dealer_rep| [dealer_rep.full_name, dealer_rep.id] } }, label: 'Dealer Representative'
  
  form title: 'Edit Dealer User' do |f|
    f.inputs 'Dealer User Details' do

      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :dealership, as: :select, collection: Dealership.order(:name) 
    end
    
    f.inputs 'Email Preferences' do

      f.input :notify_credit_decision, label: "Credit Decision"
      f.input :notify_funding_decision, label: "Funding Notification"

    end
    
    f.actions
  end

  show do |dealer|
    panel 'Dealer User details' do
      attributes_table_for dealer do
        row :id
        row :first_name
        row :last_name
        row :email
        row :dealership

        row :sign_in_count
        row :first_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip

        row :created_at
        row :updated_at
      end
    end
    div do
      panel("Audits") do
        table_for(Admins::AuditDecorator.wrap(dealer.retrieve_audits)) do
          column :created_at
          column 'Dealer', :audited
          column 'By Who', :user
          column 'Changes', :audited_changes
        end
      end
    end
    active_admin_comments
  end

  action_item(:trigger_password_reset, only: :show) {
    link_to 'Trigger Password Reset', trigger_password_reset_admins_dealer_path(resource), method: :post
  }

  member_action :trigger_password_reset, method: :post do
    dealer = Dealer.find(params[:id])
    dealer.send_reset_password_instructions
    flash[:notice] = "Password Reset Triggered."
    redirect_back fallback_location: admins_root_path
  end
end