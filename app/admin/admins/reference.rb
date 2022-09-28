ActiveAdmin.register Reference, namespace: :admins do
  belongs_to :lease_application

  permit_params :first_name, :last_name, :phone_number, :city, :state, :lease_application_id
  actions :all, except: [:destroy]

  filter :first_name_or_last_name_cont
  filter :phone_number

  index do
    column :first_name
    column :last_name
    column :phone_number
    column :city
    column :state
    actions
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
      f.input :phone_number
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
          flash[:notice] = "Reference '#{resource.full_name}' successfully added."
          redirect_to new_admins_lease_application_reference_path(parent) and return
        end
      end
    end
  end
end
