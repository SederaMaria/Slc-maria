namespace :generate_tax_jurisdiction do
    desc 'Generate New Jersey Tax Jurisdiction'
    task new_jersey: :environment do
        #activate in calculator
        new_jersey = UsState.where(abbreviation: "NJ").first
        new_jersey.active_on_calculator = true
        new_jersey.save

        tax_rule = TaxRule.create(
            name: 'New Jersey',
            sales_tax_percentage:     0.0000,
            up_front_tax_percentage:  6.625,
            cash_down_tax_percentage: 0.0000,
            effective_date: Date.today,
            end_date: "2999-12-31".to_date,
            rule_type: 'state'
          )

        #create tax jurisdiction
        tax_jurisdiction = TaxJurisdiction.create(
            name: 'New Jersey',
            us_state: 'new_jersey',
            us_states_id: new_jersey.id,
            state_tax_rule: tax_rule,
            tax_record_types_id: 1
        )

    end

  end
  