class TaxJurisdictionImporter
  attr_accessor :default_state_rate, :state_db_column_name, :tax_region_column, :local_tax_rate_column, :county_rate_column, :city_rate_column, :csv

  def initialize(default_state_rate:, state_db_column_name:, tax_region_column:, local_tax_rate_column:, county_rate_column:, city_rate_column:, csv:)
    @default_state_rate    = default_state_rate
    @state_db_column_name  = state_db_column_name
    @tax_region_column     = tax_region_column
    @local_tax_rate_column = local_tax_rate_column
    @county_rate_column    = county_rate_column
    @city_rate_column      = city_rate_column
    @csv                   = csv
  end

  def self.import(*args)
    new(*args).import
  end

  def import
    log('Starting import!')
    CSV.parse(csv, headers: true) do |row|
      log("Parsing Row: #{row}")
      find_or_create_tax_jurisdiction(row)
    end
  end

  private

    def find_or_create_county_tax_rule(zipcode_data)
      log("Setting Rates for #{"#{zipcode_data[tax_region_column]}"}: (#{zipcode_data[county_rate_column].to_f}, #{zipcode_data[county_rate_column].to_f}, #{zipcode_data[county_rate_column].to_f})")

      TaxRule.county.where(name: "#{zipcode_data[tax_region_column]}").first_or_create(
        sales_tax_percentage:     zipcode_data[county_rate_column].to_f,
        up_front_tax_percentage:  zipcode_data[county_rate_column].to_f,
        cash_down_tax_percentage: zipcode_data[county_rate_column].to_f
      ) unless zipcode_data[county_rate_column].to_f.zero?
    end

    def find_or_create_local_tax_rule(zipcode_data)
      log("Setting Rates for #{"#{zipcode_data[tax_region_column]} LOCAL"}: (#{zipcode_data[city_rate_column].to_f}, #{zipcode_data[city_rate_column].to_f}, #{zipcode_data[city_rate_column].to_f})")

      TaxRule.local.where(name: "#{zipcode_data[tax_region_column]} LOCAL").first_or_create(
        sales_tax_percentage:     zipcode_data[city_rate_column].to_f,
        up_front_tax_percentage:  zipcode_data[city_rate_column].to_f,
        cash_down_tax_percentage: zipcode_data[city_rate_column].to_f
      ) unless zipcode_data[city_rate_column].to_f.zero?
    end

    def find_or_create_tax_jurisdiction(zipcode_data)
      TaxJurisdiction.where(name: zipcode_data[local_tax_rate_column], us_state: state_db_column_name).first_or_create(
        state_tax_rule:  state_rule,
        county_tax_rule: find_or_create_county_tax_rule(zipcode_data),
        local_tax_rule:  find_or_create_local_tax_rule(zipcode_data),
        )
    end

    def state_rule
      @state_rule ||= TaxRule.state.where(name: state_db_column_name.humanize.titleize).first_or_create(
        sales_tax_percentage:     default_state_rate,
        up_front_tax_percentage:  default_state_rate,
        cash_down_tax_percentage: default_state_rate
      )
    end

    def log(string)
      Rails.logger.info(string)
      puts(string)
    end
end
