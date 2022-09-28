ActiveAdmin.register FundingDelay, namespace: :admins do
  menu parent: 'Lease Application Related'
  actions :all, except: [:new, :create, :destroy]
  config.filters = false

  controller do
    def scoped_collection
      super.includes(:lease_application, :funding_delay_reason).limit(1000)
    end

    def permitted_params
      params.permit!
    end

    def update
      status = super ? :ok : :bad
      head status and return if !!request.xhr?
    end
  end

  index do
    id_column
    column "Lease Application ID" do |delay|
      link_to delay.lease_application_id, admins_lease_application_path(delay.lease_application_id)
    end
    column "Funding Delay Reason ID" do |delay|
      link_to delay.funding_delay_reason_id, admins_funding_delay_reason_path(delay.funding_delay_reason_id)
    end
    column :notes
    column :status
    column :created_at
    column :updated_at
    actions
  end
end