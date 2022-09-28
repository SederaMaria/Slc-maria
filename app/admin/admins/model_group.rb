ActiveAdmin.register ModelGroup, namespace: :admins do
  menu parent: 'Asset Related'
  actions :all, except: [:destroy]

  decorate_with Admins::ModelGroupDecorator

  controller do
    def scoped_collection
      super.includes(:make).limit(1000)
    end

    def permitted_params
      params.permit!
    end

    def update
      update! do |success, _failure|
        success.html do
          if resource.maximum_term_length_per_year.present?
            # This makes sure JSON saved is not string but a hash
            data = JSON.parse(resource.maximum_term_length_per_year) rescue nil
            if data
              resource.maximum_term_length_per_year = data
              resource.save
            end
          end

          redirect_to admins_model_group_path(resource)
        end
      end
    end
  end

  index do
    id_column
    column :name
    column :make
    column :minimum_dealer_participation
    column :backend_advance_minimum
    column :residual_reduction_percentage
    column :maximum_term_length
    column :maximum_term_length_per_year
    actions
  end

  filter :name
  filter :make

  show do |resource|
    attributes_table do
      row :name
      row :make
      row :minimum_dealer_participation
      row :backend_advance_minimum
      row :residual_reduction_percentage
      row :maximum_term_length
      row :maximum_term_length_per_year
      row :created_at
      row :updated_at
      row :maximum_haircut_0
      row :maximum_haircut_1
      row :maximum_haircut_2
      row :maximum_haircut_3
      row :maximum_haircut_4
      row :maximum_haircut_5
      row :maximum_haircut_6
      row :maximum_haircut_7
      row :maximum_haircut_8
      row :maximum_haircut_9
      row :maximum_haircut_10
      row :maximum_haircut_11
      row :maximum_haircut_12
      row :maximum_haircut_13
      row :maximum_haircut_14
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "ModelGroup Details" do
      f.input :name
      f.input :make, include_blank: false
      f.input :minimum_dealer_participation, as: :number, input_html: { disabled: true } 
      f.input :backend_advance_minimum, as: :number
      f.input :residual_reduction_percentage
      f.input :maximum_haircut_0, as: :number, max: 1
      f.input :maximum_haircut_1, as: :number, max: 1
      f.input :maximum_haircut_2, as: :number, max: 1
      f.input :maximum_haircut_3, as: :number, max: 1
      f.input :maximum_haircut_4, as: :number, max: 1
      f.input :maximum_haircut_5, as: :number, max: 1
      f.input :maximum_haircut_6, as: :number, max: 1
      f.input :maximum_haircut_7, as: :number, max: 1
      f.input :maximum_haircut_8, as: :number, max: 1
      f.input :maximum_haircut_9, as: :number, max: 1
      f.input :maximum_haircut_10, as: :number, max: 1
      f.input :maximum_haircut_11, as: :number, max: 1
      f.input :maximum_haircut_12, as: :number, max: 1
      f.input :maximum_haircut_13, as: :number, max: 1
      f.input :maximum_haircut_14, as: :number, max: 1
    end
    f.inputs "Maximum Term Length" do
      f.input :maximum_term_length, label: "Maximum term length (default)", as: :select, collection: LeaseCalculator::TERMS
      f.input :maximum_term_length_per_year, label: "Maximum term length (year specific)", as: :jsonb
    end
    f.actions
  end
end