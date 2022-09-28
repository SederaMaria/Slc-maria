ActiveAdmin.register CreditTier, namespace: :admins do
  menu parent: "Calculator Related"
  actions :all, except: [:destroy]

  controller do
    def scoped_collection
      super.includes(:make).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end

  index title: 'Credit Tiers' do
    column :id 
    column :position 
    column :make_id do |resource|
      resource.make.try(:name)
    end
    column :description
    column :irr_value
    column :created_at
    column :updated_at
    column :acquisition_fee do |resource|
      humanized_money_with_symbol(resource.acquisition_fee)
    end
    column :maximum_fi_advance_percentage
    column :maximum_advance_percentage
    column :required_down_payment_percentage
    column "Model Group" do |resource|
      resource&.model_group&.name unless resource.model_group.nil?
    end
    actions
  end
  
  form do |f|
    inputs do
      f.input :make_id, label: "Make", as: :select, collection:  Make.pluck(:name, :id)
      f.input :model_group, as: :select, collection: resource&.make&.model_groups&.pluck(:name, :id), input_html: { class: "select2-input credit-tier-model-group" }
      f.input :position                         
      f.input :description                      
      f.input :irr_value
      f.input :maximum_fi_advance_percentage
      f.input :maximum_advance_percentage
      f.input :required_down_payment_percentage
      f.input :acquisition_fee, as: :number
      f.input :security_deposit, as: :number
      f.input :enable_security_deposit, as: :boolean
      f.input :effective_date
      f.input :end_date
      f.actions
    end
  end
  
  filter :make, as: :select, collection: proc { Make.active.pluck(:name, :id) }, label: 'Make'
  filter :position
  filter :description
  filter :irr_value
  filter :created_at
  filter :updated_at
  filter :maximum_fi_advance_percentage
  filter :maximum_advance_percentage
  filter :required_down_payment_percentage
  filter :security_deposit
  filter :enable_security_deposit
  filter :acquisition_fee
  filter :effective_date
  filter :end_date
  
end