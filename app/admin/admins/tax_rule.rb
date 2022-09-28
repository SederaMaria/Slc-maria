ActiveAdmin.register TaxRule, namespace: :admins do
  menu parent: 'Calculator Related'
  actions :all, except: [:destroy]
  decorate_with TaxRuleDecorator

  controller do
    def permitted_params
      params.permit!
    end
  end
  
  filter :by_tax_jurisdiction, as: :select, collection: proc { TaxJurisdiction.pluck(:name, :id) }
  filter :name
  filter :sales_tax_percentage
  filter :up_front_tax_percentage
  filter :cash_down_tax_percentage
  filter :rule_type
  filter :created_at
  filter :updated_at
  filter :geocode_state
  filter :geocode_county
  filter :geocode_city
  filter :geo_code
  filter :effective_date
  filter :prior_rate
end
