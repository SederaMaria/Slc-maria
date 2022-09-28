namespace :tax_jurisdictions do
  namespace :florida do
    desc 'Import/Update Tax Jurisdictions and Rules'
    task import: :environment do
      florida_state_rule = TaxRule.state.where(name: 'Florida').first_or_create({
        sales_tax_percentage: 6.0,
        up_front_tax_percentage: 6.0,
        cash_down_tax_percentage: 6.0
      })
      
      {
        'Alachua' => 0.5,
        'Baker' => 1.0,
        'Bay' => 1.0,
        'Bradford' => 1.0,
        'Brevard' => 1.0,
        'Broward' => 0.0,
        'Calhoun' => 1.5,
        'Charlotte' => 1.0,
        'Citrus' => 0.0,
        'Clay' => 1.0,
        'Collier' => 0.0,
        'Columbia' => 1.0,
        'De Soto' => 1.5,
        'Dixie' => 1.0,
        'Duval' => 1.0,
        'Escambia' => 1.5,
        'Flagler' => 1.0,
        'Franklin' => 1.0,
        'Gadsden' => 1.5,
        'Gilchrist' => 1.0,
        'Glades' => 1.0,
        'Gulf' => 1.0,
        'Hamilton' => 1.0,
        'Hardee' => 1.0,
        'Hendry' => 1.0,
        'Hernando' => 0.5,
        'Highlands' => 1.5,
        'Hillsborough' => 1.0,
        'Holmes' => 1.0,
        'Indian River' => 1.0,
        'Jackson' => 1.5,
        'Jefferson' => 1.0,
        'Lafayette' => 1.0,
        'Lake' => 1.0,
        'Lee' => 0.0,
        'Leon' => 1.5,
        'Levy' => 1.0,
        'Liberty' => 2.0,
        'Madison' => 1.5,
        'Manatee' => 1.0,
        'Marion' => 1.0,
        'Martin' => 0.0,
        'Miami-Dade' => 1.0,
        'Monroe' => 1.5,
        'Nassau' => 1.0,
        'Okaloosa' => 0.0,
        'Okeechobee' => 1.0,
        'Orange' => 0.5,
        'Osceola' => 1.5,
        'Palm Beach' => 1.0,
        'Pasco' => 1.0,
        'Pinellas' => 1.0,
        'Polk' => 1.0,
        'Putnam' => 1.0,
        'St. Johns' => 1.0,
        'St. Lucie' => 1.0,
        'Santa Rosa' => 1.0,
        'Sarasota' => 0.5,
        'Seminole' => 0.5,
        'Sumter' => 1.0,
        'Suwannee' => 1.0,
        'Taylor' => 1.0,
        'Union' => 1.0,
        'Volusia' => 0.5,
        'Wakulla' => 1.0,
        'Walton' => 1.0,
        'Washington' => 1.0,
      }.each do |k,v|
        tj = TaxJurisdiction.where(name: "#{k} County", us_state: 'florida').first_or_create({
          state_tax_rule: florida_state_rule
        })

        # TODO Works great until there are more states and county names start to overlap.
        # Washinton, Sumter, Jefferson, Lee, etc etc....
        # TaxRules will have to have the state name added to the name to ensure we don't have overlap.
        # A unique constraint would help head this off too and alert us when it happens too.
        county_tax_rule = TaxRule.county.where(name: "#{k} County FL").first_or_initialize
        county_tax_rule.sales_tax_percentage = v
        county_tax_rule.up_front_tax_percentage = v
        county_tax_rule.cash_down_tax_percentage = v
        county_tax_rule.save

        tj.update(county_tax_rule: county_tax_rule)
      end
    end
  end
end