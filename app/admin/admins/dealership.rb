ActiveAdmin.register_page "Dealerships", namespace: :admins do
  menu parent: 'Dealer Related', url: "#{ENV['LOS_UI_URL']}/dealerships"
=begin
  actions :all, except: [:destroy]

  index do
    selectable_column
    id_column
    column :name
    column :website
    column :state
    column :representatives do |dealership|
      dealership.dealer_representatives.pluck(:email).to_sentence
    end
    column :primary_contact_phone
    column :use_experian
    column :use_equifax
    column :use_transunion
    column :can_submit
    column :can_see_banner
    column :active
    actions
  end

  filter :name
  filter :active
  filter :by_dealer_representative, :as => :select, collection: proc { DealerRepresentative.joins("JOIN admin_users as au ON dealer_representatives.email = au.email ORDER BY dealer_representatives.first_name, dealer_representatives.last_name").map{|dealer_rep| [dealer_rep.full_name, dealer_rep.id] } }, label: 'Dealer Representative'
  filter :state
  filter :use_transunion, label: 'Transunion'
  filter :use_experian, label: 'Experian'
  filter :use_equifax, label: 'Equifax'

  form do |f|
    f.inputs "Dealership Details" do
      f.input :name
      f.input :website
      f.input :primary_contact_phone, input_html: { data: { mask: '(999) 999-9999' } }
      f.input :state, as: :select, collection: States::SELECT2_ABBREVIATED_ALL
      f.input :legal_corporate_entity
      f.input :dealer_group
      f.input :agreement_signed_on, as: :datepicker, datepicker_options: { dateFormat: "mm/dd/yy" },
    input_html: { data: { mask: '99/99/9999' } }
      f.input :executed_by_name
      f.input :executed_by_title
      f.input :executed_by_slc_on, as: :datepicker, datepicker_options: { dateFormat: "mm/dd/yy" },
    input_html: { data: { mask: '99/99/9999' } }
      f.input :los_access_date, as: :datepicker, datepicker_options: { dateFormat: "mm/dd/yy" },
    input_html: { data: { mask: '99/99/9999' } }
      f.input :remit_to_dealer_calculation, as: :select, collection: RemitToDealerCalculation.all.map {|k,v| [k.calculation_name, k.id]}.sort
      f.input :notes
    end
    f.inputs "Options" do
      f.input :franchised
      f.input :franchised_new_makes
      f.input :active
      f.input :can_submit, label: 'Dealership can submit to Speed Leasing'
      f.input :can_see_banner, label: 'Dealership can see banner messages'
    end
    f.inputs 'Credco Settings' do
      f.input :use_transunion, input_html: { onclick: 'return false;' }
      f.input :use_experian, input_html: { 'data-function' => 'require-one-ex-eq' }
      f.input :use_equifax, input_html: { 'data-function' => 'require-onee-ex-eq' }
    end
    f.inputs 'Address', for: :address do |a|
      a.input :street1,
        label: 'Street Address',
        wrapper_html: { class: 'col-sm-6' }
      a.input :street2,
        label: 'Bldg, Suite, Etc.',
        wrapper_html: { class: 'col-sm-6' }
      a.input :zipcode,
        input_html: { data: { mask: '99999' } },
        wrapper_html: { class: 'col-sm-3' }
      a.input :state,
        as: :select,
        label: 'State',
        collection: [resource&.address&.state],
        input_html: { 'data': { placeholder: 'Select a State' }, class: "select2-input" },
        wrapper_html: { class: 'required-to-submit col-sm-3' }
      a.input :county,
        as: :select,
        label: 'County',
        collection: [resource&.address&.county],
        input_html: { 'data': { placeholder: 'Select a County' }, class: "select2-input" },
        wrapper_html: {class: 'required-to-submit col-sm-3'}
      a.input :city,
        as: :select,
        label: 'City',
        collection: [resource&.address&.city],
        input_html: { 'data': { placeholder: 'Select a City' }, class: "select2-input" },
        wrapper_html: { class: 'required-to-submit col-sm-3' }
      
      
    end
    f.inputs "Representatives" do
      f.input :dealer_representatives, as: :select, collection: DealerRepresentative.all, input_html: { multiple: 'multiple' }
    end

    f.inputs 'Banking Details' do
      f.input :bank_name, label: 'Bank Name', wrapper_html: {class: 'col-sm-6'}
      f.input :account_number, label: 'Account Number', wrapper_html: {class: 'col-sm-6'}
      f.input :routing_number, label: 'Routing Number', wrapper_html: {class: 'col-sm-6'}, input_html: { data: { mask: '999999999' } }
      f.input :account_type, label: 'Account Type', as: :select, wrapper_html: {class: 'col-sm-6'}
    end

    f.inputs 'Security Deposit' do
      if current_admin_user&.role&.description == 'Administrator'
        f.input :security_deposit
        f.input :enable_security_deposit
      else
        f.input :security_deposit, input_html: { disabled: true}, wrapper_html: {class: 'security_deposit_disable'}
        f.input :enable_security_deposit, input_html: { disabled: true}, wrapper_html: {class: 'security_deposit_disable'}
      end
    end


    f.actions
  end

  show do |dealership|
    attributes_table do
      row :name
      row :website
      row :primary_contact_phone
      row :created_at
      row :updated_at
      row :state
      row :franchised
      row :franchised_new_makes
      row :legal_corporate_entity
      row :dealer_group
      row :active
      row :representatives do |dealership|
        dealership.dealer_representatives.pluck(:email).to_sentence
      end
      row :bank_name
      row :account_number
      row :routing_number
      row :account_type
      row :address do |dealership|
        dealership.address.nil? ? "" : "#{dealership.address.street1_street2}, #{dealership.address.city_state_zip}".squish
      end
      row :agreement_signed_on
      row :executed_by_name
      row :executed_by_title
      row :executed_by_slc_on
      row :los_access_date
      row :notes
      row :use_experian
      row :use_equifax
      row :use_transunion
      row :is_commission_clawback
      row :change_clawback_amount
      row :clawback_reason
    end

    div do
      panel("Audits") do
        table_for(Admins::AuditDecorator.wrap(dealership.get_commission_audits)) do
          column :created_at
          column 'Lease Application', :audited
          column 'By Who', :user
          column 'Changes', :audited_changes
        end
      end
    end
    active_admin_comments
  end

  controller do
    def permitted_params
      params.permit!
    end
 
   def transfer_vendor_to_lpc(dealership)
     TransferVendorToLeasepakJob.perform_in(10.seconds, dealership.id)
   end
   
   def validate_address
    begin
      if !MultipleAddressesValidator.new(@dealership.address.to_smarty_streets_format).valid?
        flash[:warning] = "Invalid Address"
      end
    rescue
      flash[:warning] = "Invalid Address"
    end
   end

    def new
      @dealership = Dealership.new({
        address: Address.new
      })
    end

    after_create do
      transfer_vendor_to_lpc(@dealership)
      validate_address
    end

    def edit
      resource.address = resource.build_address unless resource.address
    end
  end
=end
end
