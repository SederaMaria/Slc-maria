ActiveAdmin.register LeaseApplicationStipulation, namespace: :admins do
  menu parent: 'Lease Application Related'
  actions :all, except: [:new, :create, :destroy]
  config.filters = false
  decorate_with Admins::LeaseApplicationStipulationDecorator

  controller do
    def scoped_collection
      super.includes(:lease_application, :stipulation).limit(1000)
    end

    def permitted_params
      params.permit!
    end

    def edit
      @lease_application_stipulations = resource
      @lease_application = @lease_application_stipulations.lease_application
      super
    end

    def update
      status = super ? :ok : :bad
      head status and return if !!request.xhr?
    end

    def show
      @page_title = "Lease Application Stipulation #{resource.id}"
    end
  end

  index do
    column :lease_application
    column :stipulation
    column :status
    column :lease_application_attachment do |resource|
      link_to resource.attachment_filename, resource.attachment_url if resource.attachment
    end
    actions
  end

  form partial: 'edit_form'

  show do
    attributes_table do
      row :lease_application
      row :stipulation
      row :status
      row :lease_column_attachment do |resource|
        link_to resource.attachment_filename, resource.attachment_url if resource.attachment
      end
    end
  end

  def stipulation_params
    params.require(:lease_application_stipulation).permit!
  end
end