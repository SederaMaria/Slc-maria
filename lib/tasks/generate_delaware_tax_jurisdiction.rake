namespace :generate_delaware do
    desc 'Generate Delaware Tax Jurisdiction'
    task generate: :environment do
        #activate in calculator
        delaware = UsState.where(abbreviation: "DE").first
        delaware.active_on_calculator = true
        delaware.save

        tax_rule = TaxRule.create(
            name: 'Delaware',
            sales_tax_percentage:     1.9914,
            up_front_tax_percentage:  4.25,
            cash_down_tax_percentage: 1.9914,
            effective_date: Date.today,
            end_date: "2999-12-31".to_date,
            rule_type: 'state'
          )

        #create tax jurisdiction
        tax_jurisdiction = TaxJurisdiction.create(
            name: 'Delaware',
            us_state: 'delaware',
            us_states_id: delaware.id,
            state_tax_rule: tax_rule,
            tax_record_types_id: 1
        )

    end

  end
  