ActiveAdmin.register LeaseDocumentRequest, namespace: :admins do
  menu parent: "Lease Application Related"
  actions :all, except: [:destroy]

  index do
    id_column
    column :lease_application
    column :asset_make
    column :asset_model
    column :asset_year
    column :asset_vin
    column :asset_color
    actions
  end

  filter :lease_application
  filter :asset_make
  filter :asset_model
  filter :asset_year
  filter :asset_vin
  filter :asset_color

  show do |resource|
    attributes_table do
      row :lease_application
      row :asset_make
      row :asset_model
      row :asset_year
      row "ASSET VIN" do
        resource&.asset_vin&.upcase
      end
      row "ASSET COLOR" do
        resource&.asset_color&.upcase
      end
      row :exact_odometer_mileage
      row :trade_in_make
      row :trade_in_model
      row :trade_in_year
      row :delivery_date
      row :gap_contract_term
      row :service_contract_term
      row :ppm_contract_term
      row :tire_contract_term
      row :equipped_with
      row :notes
      row :created_at
      row :updated_at
    end
    panel "VIN Verification Details" do
      attributes_table_for resource.vin_validation do
        row :id
        row :status
        row :npa_validation_response
        row :validation_response do |vv|
          simple_format(ERB::Util.html_escape(vv.validation_response).gsub(' ', '&nbsp;'), {}, sanitize: false)
        end
      end
    end
    div do
      panel("Audits") do
        table_for(Admins::AuditDecorator.wrap(resource.retrieve_audits)) do
          column :created_at
          column 'Document Request', :audited
          column 'By Who', :user
          column 'Changes', :audited_changes
        end
      end
    end
  end

  form do |f|
    f.inputs "Lease Document Request Details" do
      f.input :asset_make
      f.input :asset_model
      f.input :asset_year
      f.input :asset_vin
      f.input :manual_vin_verification, label: "VIN manually verified"
      f.input :asset_color, as: :string
      f.input :exact_odometer_mileage
      f.input :trade_in_make
      f.input :trade_in_model
      f.input :trade_in_year
      f.input :delivery_date
      f.input :gap_contract_term
      f.input :service_contract_term
      f.input :ppm_contract_term
      f.input :tire_contract_term
      f.input :equipped_with
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes(:lease_application).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end
end