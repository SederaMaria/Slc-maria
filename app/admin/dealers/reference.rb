ActiveAdmin.register Reference, namespace: :dealers do
  belongs_to :lease_application

  permit_params :first_name, :last_name, :phone_number, :city, :state, :lease_application_id
  actions :all, except: [:show, :edit, :update, :destroy]

  scope_to do
    current_dealer.dealership
  end

  form do |f|
    panel('References') do
      table_for(lease_application.references) do
        column :first_name do |ref|
          ref.first_name
        end
        column :last_name do |ref|
          ref.last_name
        end
        column :phone_number do |ref|
          ref.phone_number
        end
        column :city do |ref|
          ref.city
        end
        column :state do |ref|
          ref.state
        end
      end
    end

    f.inputs 'Add References' do
      f.input :first_name
      f.input :last_name
      f.input :phone_number, input_html: { data: { mask: '(999) 999-9999' } }
      f.input :city
      f.input :state
      f.actions do
        f.action :submit
      end
    end
  end

  controller do
    def create
      super do |format|
        if resource.valid?
          notify_admins
          flash[:notice] = "Reference '#{resource.full_name}' successfully added."
          redirect_to new_dealers_lease_application_reference_path(parent) and return
        end
      end
    end

    def notify_admins
      DealerMailer.reference_added(application: resource.lease_application, reference: resource).deliver_later
      Notification.create_for_admins(
        notification_mode: 'InApp',
        notification_content: 'reference_added',
        notifiable: resource.lease_application
      )
    end
  end
end
