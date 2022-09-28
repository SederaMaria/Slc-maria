namespace :tax_jurisdictions do
  namespace :maryland do
    desc 'Import/Update Mississippi Tax Jurisdictions and Rules'
    task import: :environment do
      state_name = 'Maryland'

      maryland_state_rule = TaxRule.where(name: state_name).first_or_create(
        sales_tax_percentage:     0.0,
        up_front_tax_percentage:  6.0,
        cash_down_tax_percentage: 0.0,
        rule_type:                :state
      )

      TaxJurisdiction.where(name: state_name).first_or_create(
       us_state:       :maryland,
       state_tax_rule: maryland_state_rule
      )
    end
  end
end

