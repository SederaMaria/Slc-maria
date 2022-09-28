ActiveAdmin.register ModelYear, namespace: :admins do
  menu parent: 'Asset Related'
  actions :all

  controller do
    def scoped_collection
      super.includes(:model_group).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end

  collection_action(:import_excel, method: [:get, :post], title: "Import Model Years") do
    if request.post?
      message = ModelYearService.new(file: params[:excel_file]).import_model_years
      redirect_to admins_model_years_path, message
    else
      render 'import_excel'
    end
  end

  collection_action :csv_export, method: :post do
    ExportModelYearJob.perform_async(email: current_admin_user.email, filter: params[:q]&.permit!&.to_h)
    redirect_to(admins_model_years_path(q: params[:q]&.permit!), { notice: "A CSV export will shortly be sent to #{current_admin_user.email}." })
  end

  action_item :index do
    link_to 'Import Model Years', import_excel_admins_model_years_path
  end

  action_item(:recalculate_residuals, only: :index) do
    link_to 'Recalculate residuals', recalculate_residuals_admins_model_years_path, method: :put,
      data: { confirm: 'ARE YOU SURE? THIS ACTION CAN CAUSE MONTHLY PAYMENTS TO BE RECALCULATED ON UNSUBMITTED LEASES.' }
  end

  action_item(:recalculate_residual, only: :show) do
    link_to 'Recalculate Residual', recalculate_residual_admins_model_year_path(resource), method: :put,
      data: { confirm: 'ARE YOU SURE? THIS ACTION CAN CAUSE MONTHLY PAYMENTS TO BE RECALCULATED FOR THIS LEASE.' }
  end

  action_item :index do
    link_to 'Export to CSV', csv_export_admins_model_years_path(q: params[:q]&.permit!), method: :post, data: { confirm: "This will send a CSV export of Model Years to email:\n\n#{current_admin_user.email}\n\nAre you sure?" }
  end

  collection_action(:recalculate_residuals, method: :put) do
    Admins::ModelYearFacade.new.recalculate_residuals
    redirect_to collection_path, notice: 'Residuals will be recalculated shortly. Please refresh the page in a few moments.'
  end

  member_action(:recalculate_residual, method: :put) do
    RecalculateResidualsJob.perform_now(model_year_id: resource.id)
    redirect_to collection_path, notice: 'Residuals will be recalculated shortly. Please refresh the page in a few moments.'
  end

  index do
    id_column
    column :name
    column :year
    column :start_date
    column :end_date
    column :model_group
    column :slc_model_group_mapping_flag
    column :original_msrp do |resource|
      humanized_money_with_symbol(resource.original_msrp)
    end
    column :nada_avg_retail do |resource|
      humanized_money_with_symbol(resource.nada_avg_retail)
    end
    column :nada_rough do |resource|
      humanized_money_with_symbol(resource.nada_rough)
    end
    column :residual_24 do |resource|
      humanized_money_with_symbol(resource.residual_24)
    end
    column :residual_36 do |resource|
      humanized_money_with_symbol(resource.residual_36)
    end
    column :residual_48 do |resource|
      humanized_money_with_symbol(resource.residual_48)
    end
    column :residual_60 do |resource|
      humanized_money_with_symbol(resource.residual_60)
    end
    column :maximum_term_length
    actions
  end

  form do |f|
    f.inputs "Model Year Details" do
      f.input :model_group
      f.input :name
      f.input :start_date, as: :datepicker
      f.input :end_date, as: :datepicker
      f.input :year
      f.input :nada_model_number, as: :string, "required": true
      f.input :nada_volume_number, as: :string
      f.input :slc_model_group_mapping_flag, as: :boolean, wrapper_html: { class: 'col-sm-12' }
      f.input :police_bike, as: :boolean, wrapper_html: { class: 'col-sm-12' }  
      f.input :original_msrp, as: :number
      f.input :nada_avg_retail, as: :number
      f.input :nada_rough, as: :number
      f.input :residual_24, as: :number
      f.input :residual_36, as: :number
      f.input :residual_48, as: :number
      f.input :residual_60, as: :number
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
      f.input :maximum_term_length, label: "Maximum term length (specific)", as: :select, collection: LeaseCalculator::TERMS
    end
    f.actions
  end

  show do |resource|
    attributes_table do
      row :model_group
      row :name
      row :year
      row :nada_model_number
      row :nada_volume_number
      row :police_bike
      row :slc_model_group_mapping_flag
      row :original_msrp do
        humanized_money_with_symbol(resource.original_msrp)
      end
      row :nada_avg_retail do
        humanized_money_with_symbol(resource.nada_avg_retail)
      end
      row :nada_rough do
        humanized_money_with_symbol(resource.nada_rough)
      end
      row :residual_24 do
        humanized_money_with_symbol(resource.residual_24)
      end
      row :residual_36 do
        humanized_money_with_symbol(resource.residual_36)
      end
      row :residual_48 do
        humanized_money_with_symbol(resource.residual_48)
      end
      row :residual_60 do
        humanized_money_with_symbol(resource.residual_60)
      end
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
      row :maximum_term_length
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  

  filter :model_group
  filter :make, collection: proc { Make.where(active: true).map{|make| [make.name, make.id] } }, label: 'Make'
  filter :original_msrp_cents
  filter :nada_avg_retail_cents
  filter :nada_rough_cents
  filter :name
  filter :year
  filter :residual_24_cents
  filter :residual_36_cents
  filter :residual_48_cents
  filter :created_at
  filter :updated_at
  filter :model_group_id
  filter :residual_60_cents
  filter :maximum_haircut_0
  filter :maximum_haircut_1
  filter :maximum_haircut_2
  filter :maximum_haircut_3
  filter :maximum_haircut_4
  filter :maximum_haircut_5
  filter :maximum_haircut_6
  filter :maximum_haircut_7
  filter :maximum_haircut_8
  filter :maximum_haircut_9
  filter :maximum_haircut_10
  filter :maximum_haircut_11
  filter :maximum_haircut_12
  filter :maximum_haircut_13
  filter :maximum_haircut_14
  filter :maximum_term_length
  filter :start_date
  filter :end_date
  filter :nada_model_number
  filter :police_bike
  filter :nada_volume_number
  filter :slc_model_group_mapping_flag
  filter :nada_model_group_name
  
  
  
  
end