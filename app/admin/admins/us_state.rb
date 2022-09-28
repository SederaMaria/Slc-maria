ActiveAdmin.register UsState, namespace: :admins do
  actions :all
 
  decorate_with UsStateDecorator

  index do
    selectable_column
    id_column
    column :name
    column :abbreviation
    column :sum_of_payments_state
    column :active_on_calculator
    column :tax_jurisdiction_type do |record|
      record.tax_jurisdiction_type.name
    end
    column :security_deposit
    column :enable_security_deposit
    column :enable_electronic_signatures
    actions
   end

  form do |f|
    f.inputs "State Details" do
      f.input :name, as: :select, collection: all_states_for_select  #from ActiveAdmin::StateHelper
      f.input :abbreviation
      f.input :tax_jurisdiction_type, as: :select,
        # If Georgia, just show Custom as option, else, all types
        collection: ( (resource.name == 'georgia') ? [["Custom", TaxJurisdictionType.find_by(name: "Custom").id]] : TaxJurisdictionType.all.map do |record| [record.name, record.id] end ),
        input_html: { :onchange => "toggle_visibility();" }
      f.input :label_text, wrapper_html: { class: "hidden-fields" }
      f.input :hyperlink, wrapper_html: { class: "hidden-fields" }
      f.input :secretary_of_state_website, label: "Secretary of State Website"
    end
    f.inputs "State Configuration" do
      f.input :active_on_calculator
      f.input :sum_of_payments_state
    end
    f.inputs 'Security Deposit' do
      f.input :security_deposit
      f.input :enable_security_deposit
    end
    f.inputs 'Electronic Signatures' do      
      f.input :enable_electronic_signatures
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end
