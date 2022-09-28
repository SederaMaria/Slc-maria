ActiveAdmin.register BankRoutingNumber, namespace: :admins do
  actions :all, except: [:destroy]
 
  filter :routing_number
  filter :customer_name
  filter :address
  filter :city
  filter :state_code
  filter :zipcode

  form do |f|
    f.inputs "Bank Routing Number" do

      f.input :routing_number
      f.input :office_code, :as => :select, :collection => BankRoutingNumber::OFFICE_CODE, :prompt => 'Choose Office Code'
      f.input :servicing_frb_number
      f.input :record_type_code, :as => :select, :collection => BankRoutingNumber::RECORD_TYPE_CODE, :prompt => 'Choose Record Type Code'
      f.input :change_date, 
        as: :datepicker, 
        datepicker_options: { dateFormat: "mm/dd/yy" },
        input_html: { data: { mask: '99/99/9999' } }
      f.input :new_routing_number
      f.input :customer_name
      f.input :address
      f.input :city
      f.input :state_code
      f.input :zipcode
      f.input :zipcode_extension
      f.input :telephone_area_code
      f.input :telephone_prefix_number
      f.input :telephone_suffix_number
      f.input :institution_status_code, :as => :select, :collection => BankRoutingNumber::INSTITUTION_STATUS_CODE, :prompt => 'Choose Institution Status Code'
      f.input :data_view_code, :as => :select, :collection => BankRoutingNumber::DATA_VIEW_CODE, :prompt => 'Choose Data View Code'
      f.input :filler
    end
    f.actions
  end

  show do |bank_routing_number|
    attributes_table do
      row :id
      row :routing_number
      row(:office_code) { |b| get_display_value_from_options(BankRoutingNumber::OFFICE_CODE, b.office_code)} 
      row :servicing_frb_number
      row(:record_type_code) { |b| get_display_value_from_options(BankRoutingNumber::RECORD_TYPE_CODE, b.record_type_code)}
      row :change_date
      row :new_routing_number
      row :customer_name
      row :address
      row :city
      row :state_code
      row :zipcode
      row :zipcode_extension
      row :telephone_area_code
      row :telephone_prefix_number
      row :telephone_suffix_number
      row(:institution_status_code) { |b| get_display_value_from_options(BankRoutingNumber::INSTITUTION_STATUS_CODE, b.institution_status_code)}
      row(:data_view_code) { |b| get_display_value_from_options(BankRoutingNumber::DATA_VIEW_CODE, b.data_view_code)}
      row :filler
    end
    active_admin_comments
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end