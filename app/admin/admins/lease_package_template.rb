ActiveAdmin.register LeasePackageTemplate, namespace: :admins do
  menu parent: "Administration", if: proc{ current_admin_user.is_administrator? }

  decorate_with LeasePackageTemplateDecorator

  controller do
    def permitted_params
      params.permit!
    end
  end

  filter :name
  filter :document_type
  filter :enabled
  filter :created_at
  filter :updated_at
  filter :for_state, as: :select, collection: States::SELECT2_FULL_NAME_ALL

  form decorate: true do |f|
    f.inputs "Lease Package Template Details" do
      f.semantic_errors(*f.object.errors.keys)
      f.input :name, as: :string
      f.input :document_type, as: :select#, value: f.object.document_type#, collection: LeasePackageTemplate.document_types.map{|k,v| [k.titleize, k] }
      f.input :position, placeholder: 'Leave Blank to place this Template last'
      f.input :us_states, as: :select2_multiple, collection: States::SELECT2_FULL_NAME_ALL, selected: f.object.selected_states
      f.input :lease_package_template, as: :file, label: "PDF Form File", hint: f.object.filename, required: f.object.no_template?
      f.input :enabled
    end
    f.actions
  end

  index do
    id_column
    column :name do |lease_package_template|
      link_to lease_package_template.name, [:admins, lease_package_template]
    end
    column :us_states
    column :document_type do |lease_package_template|
      lease_package_template.document_type&.titleize
    end
    column :position
    column :enabled
    column :created_at
    column :updated_at
    actions
  end

  show do |template|
    attributes_table do
      row :name
      row :document_type do
      template.document_type&.titleize
    end
      row :position
      row :enabled
      row :us_states
      row :lease_package_template do
        link_to 'Download', template.template_url if template.has_template?
      end
    end

    active_admin_comments
  end
end
