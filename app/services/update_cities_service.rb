class UpdateCitiesService
  def initialize
  end

  def call
    # update_county_tables
    update_city_table
  end

  private
    def update_city_table
      doc = Roo::Spreadsheet.open('db/2019-05-16_cities.xlsx')
      doc.each do |row|
        # row[0] => geo_state
        # row[1] => geo_county
        # row[2] => geo_city
        # row[3] => us_state_id
        # row[4] => name
        # row[5] => city_zip_begin
        # row[6] => city_zip_end
        unless row[4] == "name"
          name           = row[0]
          county          = row[1]
          city_zip_begin            = row[2]
          city_zip_end     = row[3]
          geo_state            = row[4]
          geo_county            = row[5]
          geo_city            = row[6]
          us_state_id            = row[7]
          puts "********************************************* Cities Attributes Start ********************** "
          puts "state: #{geo_state}"
          puts "county: #{geo_county}"
          puts "city: #{geo_city}"
          puts "name: #{name}"
          puts "city_zip_begin: #{city_zip_begin}"
          puts "city_zip_end: #{city_zip_end}"
          puts "CountyID: #{county}"
          puts "StateID: #{us_state_id}"
          puts "********************************************* Cities Attributes End ********************** "
          name.present? && City.create(us_state_id: us_state_id, county_id: county, geo_state: geo_state,
                                       geo_county: geo_county, geo_city: geo_city, name: name.strip,
                                       city_zip_begin: city_zip_begin, city_zip_end: city_zip_end)
        end
      end
   end
    def update_county_tables
      doc = Roo::Spreadsheet.open('db/missing_counties.xlsx')
      doc.each do |row|
        # row[0] => geo_state
        # row[1] => geo_county
        # row[2] => geo_city
        # row[3] => us_state_id
        # row[4] => name
        # row[5] => city_zip_begin
        # row[6] => city_zip_end
        unless row[1] == "name"
          us_state_id     = row[0]
          name            = row[1]
          puts "********************"
          puts "State => #{us_state_id}"
          puts "Name => #{name}"
          puts "********************"
          County.create(us_state_id: us_state_id, name: name)
        end
      end
   end
end
