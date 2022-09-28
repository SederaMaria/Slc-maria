namespace :tax_jurisdictions do
  namespace :pennsylvania do
    desc 'Import/Update Pennsylvania Tax Jurisdictions and Rules'
    task import: :environment do
      CSV.parse(pennsylvania_data, headers: true) do |row|
        find_or_create_pennsylvania_county_tax_rule(row)
        find_or_create_pennsylvania_tax_jurisdiction(row)
      end
    end

    def find_or_create_pennsylvania_county_tax_rule(zipcode_data)
      county_name              = "#{zipcode_data['TaxRegionName']} PA"
      sales_tax_percentage     = zipcode_data['CountyRate'].to_f
      up_front_tax_percentage  = zipcode_data['CountyRate'].to_f
      cash_down_tax_percentage = zipcode_data['CountyRate'].to_f

      Rails.logger.info("Setting Rates for #{county_name}: (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      TaxRule.county.where(name: county_name).first_or_create(
        sales_tax_percentage:     sales_tax_percentage,
        up_front_tax_percentage:  up_front_tax_percentage,
        cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def find_or_create_pennsylvania_local_tax_rule(zipcode_data)
      city_name                = "#{zipcode_data['TaxRegionName']} LOCAL"
      sales_tax_percentage     = zipcode_data['CityRate'].to_f
      up_front_tax_percentage  = zipcode_data['CityRate'].to_f
      cash_down_tax_percentage = zipcode_data['CityRate'].to_f

      Rails.logger.info("Setting Rates for #{city_name}: (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      TaxRule.local.where(name: city_name).first_or_create(
        sales_tax_percentage:     sales_tax_percentage,
        up_front_tax_percentage:  up_front_tax_percentage,
        cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def find_or_create_pennsylvania_tax_jurisdiction(zipcode_data)
      name            = zipcode_data['TaxRegionName']
      us_state        = 'pennsylvania'
      state_tax_rule  = pennsylvania_state_rule
      county_tax_rule = find_or_create_pennsylvania_county_tax_rule(zipcode_data)
      local_tax_rule  = find_or_create_pennsylvania_local_tax_rule(zipcode_data)

      TaxJurisdiction.where(name: name, us_state: us_state).first_or_create(
        state_tax_rule:  state_tax_rule,
        county_tax_rule: county_tax_rule,
        local_tax_rule:  local_tax_rule,
        )
    end

    def pennsylvania_state_rule
      @pennsylvania_state_rule ||= TaxRule.state.where(name: 'Pennsylvania').first_or_create(
        sales_tax_percentage:     9.00,
        up_front_tax_percentage:  9.00,
        cash_down_tax_percentage: 9.00
      )
    end

    def pennsylvania_data
      <<-HEREDOC
State,ZipCode,TaxRegionName,TaxRegionCode,Combined Rate,StateRate,CountyRate,CityRate,SpecialRate
PA,,Allegheny County,,10.000%,9.000%,0.000%,1%,0%
PA,,Philadelphia County,,11.000%,9.000%,0.000%,2%,0%
PA,,All Other Counties,,9.000%,9.000%,0.000%,0%,0%
      HEREDOC
    end
  end
end
