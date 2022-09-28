namespace :tax_jurisdictions do
	namespace :mississippi do
		desc 'Import/Update Mississippi Tax Jurisdictions and Rules'
		task import: :environment do
			mississippi_state_rule = TaxRule.where(name: 'Mississippi').first_or_create({
				                                                                            sales_tax_percentage:     7.0,
				                                                                            up_front_tax_percentage:  7.0,
				                                                                            cash_down_tax_percentage: 7.0,
				                                                                            rule_type:                :state
			                                                                            })

			TaxJurisdiction.where(name: 'Mississippi').first_or_create({
				                                                           us_state:       :mississippi,
				                                                           state_tax_rule: mississippi_state_rule,
			                                                           })
		end
	end
end

