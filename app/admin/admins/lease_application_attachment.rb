ActiveAdmin.register LeaseApplicationAttachment, namespace: :admins do
  menu parent: "Lessee Related"
  actions :all, except: [:destroy]
  config.filters = false

  controller do
    def scoped_collection
      super.includes(:lease_application).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end

  member_action :toggle_visibility, method: :put do
    resource.toggle! :visible_to_dealers
    redirect_back fallback_location: admins_root_path, notice: 'Visibility changed successfully'
  end

  index do
    id_column
    column "Application" do |file|
      link_to file.lease_application.id, admins_lease_application_path(file.lease_application)
    end
    column "File Name" do |file|
      file.upload.filename
    end
    column "Download Link" do |file|
      link_to 'Download', file.upload.url, target: '_blank'
    end
    actions
  end

  show do |file|
    attributes_table do
      row "File Name" do
        file.upload.filename
      end
      row "Download Link" do
        link_to 'Download', file.upload.url, target: '_blank'
      end
    end
    active_admin_comments
  end
end