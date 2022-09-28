ActiveAdmin.register Make, namespace: :admins do
  menu parent: 'Asset Related'
  actions :all

  controller do
    def permitted_params
      params.permit!
    end
  end

end
