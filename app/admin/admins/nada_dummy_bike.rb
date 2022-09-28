ActiveAdmin.register NadaDummyBike, namespace: :admins do
  menu parent: 'Asset Related'
  actions :all

  controller do
    def permitted_params
      params.permit!
    end
  end

  index do
    selectable_column
    id_column
    column :make
    column :year
    column :model_group_name
    column :bike_model_name
    column :nada_rough_cents
    actions
  end

  show do
  	
  end

  show do |bike|
    panel 'Nada Dummy Bikes' do
      attributes_table_for bike do
        row :make
	    row :year
	    row :model_group_name
	    row :bike_model_name
	    row :nada_rough_cents

        row :created_at
        row :updated_at
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Nada Dummy Bike' do
      f.input :make, as: :select,
      	      input_html: { 'data': { placeholder: 'Select a Make' }, class: "select2-input" }
      f.input :year
      f.input :model_group_name,
		      as: :select,
		      collection: resource&.make&.model_groups&.map(&:name) || [],
		      input_html: { 'data': { placeholder: 'Select a Model Group Name' }, class: "select2-input" }
      f.input :bike_model_name
      f.input :nada_rough_cents
    end

    f.actions do 
      f.action :submit
    end
  end
end
