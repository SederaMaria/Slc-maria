namespace :tax_jurisdictions do
  namespace :arizona do
    desc 'Import/Update Arizona Tax Jurisdictions and Rules'
    task import: :environment do
      CSV.parse(arizona_data, headers: true) do |row|
        find_or_create_arizona_county_tax_rule(row)
        find_or_create_arizona_tax_jurisdiction(row)
      end
    end

    def find_or_create_arizona_county_tax_rule(zipcode_data)
      county_name              = "#{zipcode_data['TaxRegionName']} AZ"
      sales_tax_percentage     = zipcode_data['EstimatedCountyRate'].to_f
      up_front_tax_percentage  = zipcode_data['EstimatedCountyRate'].to_f
      cash_down_tax_percentage = zipcode_data['EstimatedCountyRate'].to_f

      Rails.logger.info("Setting Rates for #{county_name}: (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      TaxRule.county.where(name: county_name).first_or_create(
        sales_tax_percentage:     sales_tax_percentage,
        up_front_tax_percentage:  up_front_tax_percentage,
        cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def find_or_create_arizona_local_tax_rule(zipcode_data)
      city_name                = "#{zipcode_data['TaxRegionName']} LOCAL"
      sales_tax_percentage     = zipcode_data['EstimatedCityRate'].to_f
      up_front_tax_percentage  = zipcode_data['EstimatedCityRate'].to_f
      cash_down_tax_percentage = zipcode_data['EstimatedCityRate'].to_f

      Rails.logger.info("Setting Rates for #{city_name}: (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      rule = TaxRule.local.where(name: city_name).first_or_create(
        sales_tax_percentage:     sales_tax_percentage,
        up_front_tax_percentage:  up_front_tax_percentage,
        cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def find_or_create_arizona_tax_jurisdiction(zipcode_data)
      name            = zipcode_data['ZipCode']
      us_state        = 'arizona'
      state_tax_rule  = arizona_state_rule
      county_tax_rule = find_or_create_arizona_county_tax_rule(zipcode_data)
      local_tax_rule  = find_or_create_arizona_local_tax_rule(zipcode_data)

      TaxJurisdiction.where(name: name, us_state: us_state).first_or_create(
        state_tax_rule:  state_tax_rule,
        county_tax_rule: county_tax_rule,
        local_tax_rule: local_tax_rule,
      )
    end

    def arizona_state_rule
      @arizona_state_rule ||= TaxRule.state.where(name: 'Arizona').first_or_create(
        sales_tax_percentage:     5.6,
        up_front_tax_percentage:  5.6,
        cash_down_tax_percentage: 5.6
      )
    end

    def arizona_data
      data = <<-CSV
State,ZipCode,TaxRegionName,StateRate,EstimatedCombinedRate,EstimatedCountyRate,EstimatedCityRate,EstimatedSpecialRate,RiskLevel
AZ,85001,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85002,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85003,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85004,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85005,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85006,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85007,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85008,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85009,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85010,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85011,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85012,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85013,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85014,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85015,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85016,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85017,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85018,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85019,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85020,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85021,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85022,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85023,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85024,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85026,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85027,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85028,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85029,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85030,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85031,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85032,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85033,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85034,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85035,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85036,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85037,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85038,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85039,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85040,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85041,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85042,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85043,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85044,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85045,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85046,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85048,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85050,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85051,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85053,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85054,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85060,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85061,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85062,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85063,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85064,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85065,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85066,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85067,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85068,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85069,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85070,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85071,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85072,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85073,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85074,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85076,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85078,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85079,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85080,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85082,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85083,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85085,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85086,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,3
AZ,85087,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,2
AZ,85097,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85117,APACHE JUNCTION (PINAL CO),5.60%,9.10%,1.10%,2.40%,0.00%,1
AZ,85118,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,4
AZ,85119,APACHE JUNCTION (PINAL CO),5.60%,9.10%,1.10%,2.40%,0.00%,3
AZ,85120,APACHE JUNCTION (PINAL CO),5.60%,9.10%,1.10%,2.40%,0.00%,1
AZ,85121,CASA GRANDE,5.60%,8.70%,1.10%,2.00%,0.00%,1
AZ,85122,CASA GRANDE,5.60%,8.70%,1.10%,2.00%,0.00%,2
AZ,85123,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85127,QUEEN CREEK (MARICOPA CO),5.60%,8.55%,0.70%,2.25%,0.00%,1
AZ,85128,COOLIDGE,5.60%,9.70%,1.10%,3.00%,0.00%,1
AZ,85130,CASA GRANDE,5.60%,8.70%,1.10%,2.00%,0.00%,1
AZ,85131,ELOY,5.60%,9.70%,1.10%,3.00%,0.00%,2
AZ,85132,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85135,HAYDEN (GILA CO),5.60%,9.60%,1.00%,3.00%,0.00%,1
AZ,85137,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85138,MARICOPA,5.60%,8.70%,1.10%,2.00%,0.00%,1
AZ,85139,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,2
AZ,85140,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,3
AZ,85141,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85142,QUEEN CREEK (MARICOPA CO),5.60%,8.55%,0.70%,2.25%,0.00%,4
AZ,85143,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,3
AZ,85145,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85147,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85172,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85173,SUPERIOR,5.60%,10.70%,1.10%,4.00%,0.00%,1
AZ,85178,APACHE JUNCTION (PINAL CO),5.60%,9.10%,1.10%,2.40%,0.00%,1
AZ,85190,APACHE JUNCTION (PINAL CO),5.60%,9.10%,1.10%,2.40%,0.00%,2
AZ,85191,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85192,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,2
AZ,85193,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85194,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85201,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85202,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85203,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85204,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85205,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85206,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85207,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85208,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85209,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85210,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85211,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85212,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85213,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85214,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85215,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85216,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85224,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85225,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85226,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85233,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85234,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85236,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85244,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85246,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85248,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,2
AZ,85249,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85250,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85251,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85252,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85253,PARADISE VALLEY,5.60%,8.80%,0.70%,2.50%,0.00%,2
AZ,85254,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85255,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85256,SALT RIVER PIMA-MARICOPA RES./MARICOPA CO,5.60%,7.95%,0.70%,0.00%,1.65%,1
AZ,85257,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85258,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85259,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85260,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85261,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85262,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85263,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,2
AZ,85264,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,2
AZ,85266,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85267,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85268,FOUNTAIN HILLS,5.60%,8.90%,0.70%,2.60%,0.00%,2
AZ,85269,FOUNTAIN HILLS,5.60%,8.90%,0.70%,2.60%,0.00%,2
AZ,85271,SCOTTSDALE,5.60%,7.95%,0.70%,1.65%,0.00%,1
AZ,85274,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85275,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85277,MESA,5.60%,8.05%,0.70%,1.75%,0.00%,1
AZ,85280,TEMPE,5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85281,TEMPE,5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85282,TEMPE,5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85283,TEMPE,5.60%,8.10%,0.70%,1.80%,0.00%,2
AZ,85284,TEMPE,5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85285,TEMPE,5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85286,CHANDLER,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85287,TEMPE,5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85295,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85296,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85297,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85298,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85299,GILBERT,5.60%,7.80%,0.70%,1.50%,0.00%,1
AZ,85301,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85302,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85303,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85304,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85305,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85306,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85307,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85308,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85309,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85310,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85311,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85312,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85318,GLENDALE,5.60%,9.20%,0.70%,2.90%,0.00%,1
AZ,85320,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85321,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85322,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85323,AVONDALE,5.60%,8.80%,0.70%,2.50%,0.00%,2
AZ,85324,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,2
AZ,85325,LA PAZ COUNTY,5.60%,7.60%,2.00%,0.00%,0.00%,1
AZ,85326,BUCKEYE,5.60%,9.30%,0.70%,3.00%,0.00%,1
AZ,85327,CAVE CREEK,5.60%,9.30%,0.70%,3.00%,0.00%,1
AZ,85328,LA PAZ COUNTY,5.60%,7.60%,2.00%,0.00%,0.00%,1
AZ,85329,AVONDALE,5.60%,8.80%,0.70%,2.50%,0.00%,1
AZ,85331,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85332,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,85333,YUMA COUNTY,5.60%,6.71%,1.11%,0.00%,0.00%,1
AZ,85334,LA PAZ COUNTY,5.60%,7.60%,2.00%,0.00%,0.00%,1
AZ,85335,EL MIRAGE,5.60%,9.30%,0.70%,3.00%,0.00%,1
AZ,85336,YUMA COUNTY,5.60%,6.71%,1.11%,0.00%,0.00%,1
AZ,85337,GILA BEND,5.60%,9.80%,0.70%,3.50%,0.00%,1
AZ,85338,GOODYEAR,5.60%,8.80%,0.70%,2.50%,0.00%,1
AZ,85339,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85340,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85341,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85342,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,2
AZ,85343,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85344,LA PAZ COUNTY,5.60%,7.60%,2.00%,0.00%,0.00%,1
AZ,85345,PEORIA (MARICOPA CO),5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85346,QUARTZSITE,5.60%,10.10%,2.00%,2.50%,0.00%,1
AZ,85347,YUMA COUNTY,5.60%,6.71%,1.11%,0.00%,0.00%,1
AZ,85348,LA PAZ COUNTY,5.60%,7.60%,2.00%,0.00%,0.00%,1
AZ,85349,SAN LUIS,5.60%,10.71%,1.11%,4.00%,0.00%,1
AZ,85350,YUMA COUNTY,5.60%,6.71%,1.11%,0.00%,0.00%,1
AZ,85351,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85352,YUMA COUNTY,5.60%,6.71%,1.11%,0.00%,0.00%,1
AZ,85353,PHOENIX,5.60%,8.60%,0.70%,2.30%,0.00%,1
AZ,85354,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85355,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85356,WELLTON,5.60%,9.21%,1.11%,2.50%,0.00%,1
AZ,85357,LA PAZ COUNTY,5.60%,7.60%,2.00%,0.00%,0.00%,1
AZ,85358,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,1
AZ,85359,QUARTZSITE,5.60%,10.10%,2.00%,2.50%,0.00%,1
AZ,85360,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,1
AZ,85361,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85362,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,85363,YOUNGTOWN,5.60%,9.30%,0.70%,3.00%,0.00%,1
AZ,85364,YUMA,5.60%,8.41%,1.11%,1.70%,0.00%,1
AZ,85365,YUMA,5.60%,8.41%,1.11%,1.70%,0.00%,2
AZ,85366,YUMA,5.60%,8.41%,1.11%,1.70%,0.00%,1
AZ,85367,YUMA COUNTY,5.60%,6.71%,1.11%,0.00%,0.00%,1
AZ,85369,YUMA,5.60%,8.41%,1.11%,1.70%,0.00%,1
AZ,85371,PARKER,5.60%,9.60%,2.00%,2.00%,0.00%,1
AZ,85372,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85373,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85374,SURPRISE,5.60%,8.50%,0.70%,2.20%,0.00%,2
AZ,85375,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,2
AZ,85376,MARICOPA COUNTY,5.60%,6.30%,0.70%,0.00%,0.00%,1
AZ,85377,CAREFREE,5.60%,9.30%,0.70%,3.00%,0.00%,1
AZ,85378,SURPRISE,5.60%,8.50%,0.70%,2.20%,0.00%,1
AZ,85379,SURPRISE,5.60%,8.50%,0.70%,2.20%,0.00%,2
AZ,85380,PEORIA (MARICOPA CO),5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85381,PEORIA (MARICOPA CO),5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85382,PEORIA (MARICOPA CO),5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85383,PEORIA (MARICOPA CO),5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85385,PEORIA (MARICOPA CO),5.60%,8.10%,0.70%,1.80%,0.00%,1
AZ,85387,SURPRISE,5.60%,8.50%,0.70%,2.20%,0.00%,3
AZ,85388,SURPRISE,5.60%,8.50%,0.70%,2.20%,0.00%,1
AZ,85390,WICKENBURG,5.60%,8.50%,0.70%,2.20%,0.00%,1
AZ,85392,AVONDALE,5.60%,8.80%,0.70%,2.50%,0.00%,1
AZ,85395,GOODYEAR,5.60%,8.80%,0.70%,2.50%,0.00%,1
AZ,85396,BUCKEYE,5.60%,9.30%,0.70%,3.00%,0.00%,1
AZ,85501,GLOBE,5.60%,8.90%,1.00%,2.30%,0.00%,1
AZ,85502,GLOBE,5.60%,8.90%,1.00%,2.30%,0.00%,1
AZ,85530,GRAHAM COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85531,GRAHAM COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85532,GLOBE,5.60%,8.90%,1.00%,2.30%,0.00%,1
AZ,85533,GREENLEE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85534,GREENLEE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85535,PIMA,5.60%,8.60%,1.00%,2.00%,0.00%,1
AZ,85536,GRAHAM COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85539,MIAMI,5.60%,9.10%,1.00%,2.50%,0.00%,1
AZ,85540,CLIFTON,5.60%,9.10%,0.50%,3.00%,0.00%,1
AZ,85541,PAYSON,5.60%,9.60%,1.00%,3.00%,0.00%,2
AZ,85542,GILA COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85543,PIMA,5.60%,8.60%,1.00%,2.00%,0.00%,2
AZ,85544,GILA COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,2
AZ,85545,GILA COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85546,SAFFORD,5.60%,9.10%,1.00%,2.50%,0.00%,1
AZ,85547,PAYSON,5.60%,9.60%,1.00%,3.00%,0.00%,1
AZ,85548,SAFFORD,5.60%,9.10%,1.00%,2.50%,0.00%,1
AZ,85550,GILA COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85551,GRAHAM COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85552,THATCHER,5.60%,9.10%,1.00%,2.50%,0.00%,1
AZ,85553,GILA COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85554,GLOBE,5.60%,8.90%,1.00%,2.30%,0.00%,1
AZ,85601,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85602,BENSON,5.60%,9.60%,0.50%,3.50%,0.00%,4
AZ,85603,BISBEE,5.60%,9.60%,0.50%,3.50%,0.00%,7
AZ,85605,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85606,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85607,DOUGLAS,5.60%,8.90%,0.50%,2.80%,0.00%,3
AZ,85608,DOUGLAS,5.60%,8.90%,0.50%,2.80%,0.00%,1
AZ,85609,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85610,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85611,SANTA CRUZ COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,2
AZ,85613,SIERRA VISTA,5.60%,8.05%,0.50%,1.95%,0.00%,2
AZ,85614,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85615,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,5
AZ,85616,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85617,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85618,MAMMOTH,5.60%,10.70%,1.10%,4.00%,0.00%,1
AZ,85619,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85620,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85621,NOGALES,5.60%,8.60%,1.00%,2.00%,0.00%,2
AZ,85622,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85623,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85624,SANTA CRUZ COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,3
AZ,85625,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,3
AZ,85626,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85627,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85628,NOGALES,5.60%,8.60%,1.00%,2.00%,0.00%,1
AZ,85629,SAHUARITA,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85630,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85631,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,1
AZ,85632,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,4
AZ,85633,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85634,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,8
AZ,85635,SIERRA VISTA,5.60%,8.05%,0.50%,1.95%,0.00%,2
AZ,85636,SIERRA VISTA,5.60%,8.05%,0.50%,1.95%,0.00%,1
AZ,85637,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85638,TOMBSTONE,5.60%,9.60%,0.50%,3.50%,0.00%,1
AZ,85639,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85640,SANTA CRUZ COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,4
AZ,85641,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,5
AZ,85643,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,9
AZ,85644,WILLCOX,5.60%,9.10%,0.50%,3.00%,0.00%,1
AZ,85645,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85646,SANTA CRUZ COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,1
AZ,85648,SANTA CRUZ COUNTY,5.60%,6.60%,1.00%,0.00%,0.00%,2
AZ,85650,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85652,MARANA,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85653,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85654,MARANA,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85655,DOUGLAS,5.60%,8.90%,0.50%,2.80%,0.00%,1
AZ,85658,MARANA,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85670,SIERRA VISTA,5.60%,8.05%,0.50%,1.95%,0.00%,2
AZ,85671,COCHISE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85701,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85702,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85703,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85704,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85705,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85706,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85707,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85708,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85709,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85710,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85711,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85712,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85713,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85714,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85715,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85716,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85717,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85718,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85719,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85720,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85721,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85723,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85724,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85725,SOUTH TUCSON,5.60%,10.60%,0.50%,4.50%,0.00%,2
AZ,85726,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85728,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85730,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85731,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85732,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85733,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85734,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85735,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85736,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85737,ORO VALLEY,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85738,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85739,PINAL COUNTY,5.60%,6.70%,1.10%,0.00%,0.00%,3
AZ,85740,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85741,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85742,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85743,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85744,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85745,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85746,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85747,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85748,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85749,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85750,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85751,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85752,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85754,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,1
AZ,85755,ORO VALLEY,5.60%,8.60%,0.50%,2.50%,0.00%,2
AZ,85756,TUCSON,5.60%,8.60%,0.50%,2.50%,0.00%,3
AZ,85757,PIMA COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85901,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,2
AZ,85902,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85911,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,2
AZ,85912,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85920,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85922,GREENLEE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85923,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85924,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85925,EAGAR,5.60%,9.10%,0.50%,3.00%,0.00%,1
AZ,85926,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85927,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85928,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,85929,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85930,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,2
AZ,85931,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,3
AZ,85932,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85933,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85934,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85935,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,85936,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,5
AZ,85937,SNOWFLAKE,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85938,SPRINGERVILLE,5.60%,9.10%,0.50%,3.00%,0.00%,2
AZ,85939,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85940,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85941,SHOW LOW,5.60%,8.10%,0.50%,2.00%,0.00%,1
AZ,85942,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,2
AZ,86001,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86002,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86003,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86004,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86005,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86011,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86015,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,2
AZ,86016,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,2
AZ,86017,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,2
AZ,86018,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,2
AZ,86020,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,2
AZ,86021,COLORADO,5.60%,8.85%,0.25%,3.00%,0.00%,1
AZ,86022,FREDONIA,5.60%,10.90%,1.30%,4.00%,0.00%,5
AZ,86023,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,3
AZ,86024,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,2
AZ,86025,HOLBROOK,5.60%,9.10%,0.50%,3.00%,0.00%,2
AZ,86028,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,2
AZ,86029,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,3
AZ,86030,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86031,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,4
AZ,86032,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86033,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,5
AZ,86034,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86035,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,1
AZ,86036,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,1
AZ,86038,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,2
AZ,86039,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,8
AZ,86040,PAGE,5.60%,9.90%,1.30%,3.00%,0.00%,3
AZ,86042,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,4
AZ,86043,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,5
AZ,86044,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,3
AZ,86045,FLAGSTAFF,5.60%,8.95%,1.30%,2.05%,0.00%,5
AZ,86046,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,1
AZ,86047,WINSLOW,5.60%,9.10%,0.50%,3.00%,0.00%,4
AZ,86052,FREDONIA,5.60%,10.90%,1.30%,4.00%,0.00%,2
AZ,86053,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,3
AZ,86054,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,3
AZ,86301,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,1
AZ,86302,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,1
AZ,86303,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,2
AZ,86304,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,1
AZ,86305,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,2
AZ,86312,PRESCOTT VALLEY,5.60%,9.18%,0.75%,2.83%,0.00%,1
AZ,86313,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,1
AZ,86314,PRESCOTT VALLEY,5.60%,9.18%,0.75%,2.83%,0.00%,1
AZ,86315,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86320,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86321,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,1
AZ,86322,CAMP VERDE,5.60%,10.00%,0.75%,3.65%,0.00%,1
AZ,86323,CHINO VALLEY,5.60%,10.35%,0.75%,4.00%,0.00%,1
AZ,86324,CLARKDALE,5.60%,9.35%,0.75%,3.00%,0.00%,1
AZ,86325,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86326,COTTONWOOD,5.60%,9.35%,0.75%,3.00%,0.00%,1
AZ,86327,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86329,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,1
AZ,86331,JEROME,5.60%,9.85%,0.75%,3.50%,0.00%,1
AZ,86332,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,2
AZ,86333,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,4
AZ,86334,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86335,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86336,SEDONA (YAVAPAI CO),5.60%,9.35%,0.75%,3.00%,0.00%,2
AZ,86337,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86338,PRESCOTT,5.60%,8.35%,0.75%,2.00%,0.00%,1
AZ,86339,SEDONA (COCONINO CO),5.60%,9.90%,1.30%,3.00%,0.00%,2
AZ,86340,SEDONA (YAVAPAI CO),5.60%,9.35%,0.75%,3.00%,0.00%,2
AZ,86341,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,2
AZ,86342,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86343,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,1
AZ,86351,YAVAPAI COUNTY,5.60%,6.35%,0.75%,0.00%,0.00%,2
AZ,86401,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,3
AZ,86402,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,1
AZ,86403,LAKE HAVASU CITY,5.60%,7.85%,0.25%,2.00%,0.00%,2
AZ,86404,LAKE HAVASU CITY,5.60%,7.85%,0.25%,2.00%,0.00%,1
AZ,86405,LAKE HAVASU CITY,5.60%,7.85%,0.25%,2.00%,0.00%,1
AZ,86406,LAKE HAVASU CITY,5.60%,7.85%,0.25%,2.00%,0.00%,1
AZ,86409,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86411,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86412,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86413,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86426,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86427,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86429,BULLHEAD,5.60%,7.85%,0.25%,2.00%,0.00%,1
AZ,86430,BULLHEAD,5.60%,7.85%,0.25%,2.00%,0.00%,1
AZ,86431,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,1
AZ,86432,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86433,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,1
AZ,86434,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,4
AZ,86435,COCONINO COUNTY,5.60%,6.90%,1.30%,0.00%,0.00%,1
AZ,86436,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86437,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86438,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,1
AZ,86439,BULLHEAD,5.60%,7.85%,0.25%,2.00%,0.00%,1
AZ,86440,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,1
AZ,86441,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,1
AZ,86442,BULLHEAD,5.60%,7.85%,0.25%,2.00%,0.00%,1
AZ,86443,KINGMAN,5.60%,8.35%,0.25%,2.50%,0.00%,2
AZ,86444,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,1
AZ,86445,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,3
AZ,86446,MOHAVE COUNTY,5.60%,5.85%,0.25%,0.00%,0.00%,2
AZ,86503,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,9
AZ,86504,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86505,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,11
AZ,86506,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,5
AZ,86507,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,4
AZ,86510,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,86511,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,5
AZ,86512,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86514,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,5
AZ,86515,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86520,NAVAJO COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86535,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86538,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86540,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86545,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,1
AZ,86547,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
AZ,86556,APACHE COUNTY,5.60%,6.10%,0.50%,0.00%,0.00%,2
      CSV

    end
  end
end