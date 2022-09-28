ActiveAdmin.register FundingDelayReason, namespace: :admins do
  menu parent: 'Administration', if: proc{ current_admin_user.is_administrator? }

  actions :all, except: [:destroy]

  controller do
    def permitted_params
      params.permit!
    end
  end
end
