ActiveAdmin.register TaxJurisdiction, namespace: :admins do
  menu parent: 'Calculator Related'
  actions :all, except: [:destroy]

  action_item :index do
    link_to 'Export to CSV', csv_export_admins_tax_jurisdictions_path(q: params[:q]&.permit!), method: :post, data: { confirm: "This will send a CSV export of Tax Jurisdictions to email:\n\n#{current_admin_user.email}\n\nAre you sure?" }
  end

  collection_action :csv_export, method: :post do
    ExportTaxJurisdictionsJob.perform_async(email: current_admin_user.email, filter: params[:q]&.permit!&.to_h)
    redirect_to(admins_tax_jurisdictions_path(q: params[:q]&.permit!), { notice: "A CSV export will shortly be sent to #{current_admin_user.email}." })
  end

  decorate_with Admins::TaxJurisdictionDecorator

  controller do
    def scoped_collection
      super.includes(:state_tax_rule, :county_tax_rule, :local_tax_rule).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end

  index download_links: false do
    id_column
    column :name
    column :us_state
    column :state_tax_rule
    column :county_tax_rule
    column :local_tax_rule
    column :total_sales_tax_percentage
    actions
  end

  filter :name
  filter :us_state, as: :select, collection: TaxJurisdiction.us_states.map {|k,v| [k.titleize, v]}.sort
  filter :state_tax_rule, as: :select, collection: proc { TaxRule.state.order(:name) }
  filter :county_tax_rule, as: :select, collection: proc { TaxRule.county.order(:name) }
  filter :local_tax_rule, as: :select, collection: proc { TaxRule.local.order(:name) }

  show do |resource|
    attributes_table do
      row :name
      row :us_state
      row :state_tax_rule
      row :county_tax_rule
      row :local_tax_rule
      row :total_sales_tax_percentage
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Tax Jurisdiction Details" do
      f.input :name
      f.input :us_state, as: :select, collection: TaxJurisdiction.us_states.map {|k,v| [k.titleize, k]}.sort
      f.input :state_tax_rule, as: :select, collection: TaxRule.state.order(:name)
      f.input :county_tax_rule, as: :select, collection: TaxRule.county.order(:name)
      f.input :local_tax_rule, as: :select, collection: TaxRule.local.order(:name)
    end
    f.actions
  end
end