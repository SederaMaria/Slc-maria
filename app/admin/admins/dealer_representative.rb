ActiveAdmin.register DealerRepresentative, namespace: :admins do
  menu parent: 'Dealer Related'
  actions :all

  controller do
    def permitted_params
      params.permit!
    end
  end

  filter :dealerships

  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column 'Dealerships' do |rep|
      rep.dealerships.count
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :full_name
      row :email
      row :dealerships do |rep|
        rep.dealerships.pluck(:name).to_sentence
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs
    f.inputs "Dealerships" do
      f.input :dealerships, as: :select, collection: Dealership.all.order(:name), input_html: { multiple: 'multiple' }
    end
    f.inputs "Admin User" do
      f.input :admin_user, as: :select, collection: AdminUser.all.where(is_active: true).order(:first_name)
    end
    f.actions
  end
end
