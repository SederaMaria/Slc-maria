namespace :counties do
  # bundle exec rake counties:import_from_csv
  task import_from_csv: :environment do 
    file_path = "#{Rails.root}/db/counties.csv"
    contents = Roo::CSV.new(file_path,
                            csv_options: { encoding: Encoding::ISO_8859_1 })
    header = contents.row(1)
    (2..contents.last_row).each do |i|
      row = Hash[[header, contents.row(i)].transpose]
      county = County.where(us_state_id: row['us_state_id'], 
                            name: row['name']).first_or_create
      

      p "#{county.id} - #{county.name}"

    end
  end

  desc 'Update counties with geo_code_county'
  task update_counties_with_geo_codes: :environment do
    ActiveRecord::Base.connection.execute(<<-SQL)
      UPDATE counties AS c
      SET geo_code_county = a.geo_county
      FROM (
          SELECT DISTINCT co.id, ci.geo_county
          FROM counties AS co
          JOIN cities AS ci ON co.id = ci.county_id   
        ) AS a
      WHERE c.id = a.id;     
    SQL
  end

  desc 'Delete counties where spellings not matching Vertex and correct rows also exist'
  task delete_unused_inaccurate_rows: :environment do
    ActiveRecord::Base.connection.execute(<<-SQL)
      DELETE FROM counties 
      WHERE (us_state_id = 22 AND name = 'BALTIMORE (IND CITY)' AND geo_code_county IS NULL)
      OR (us_state_id = 47 AND name = 'FAIRFAX (IND CITY)' AND geo_code_county IS NULL)
      OR (us_state_id = 47 AND name = 'FRANKLIN (IND CITY)' AND geo_code_county IS NULL)
      OR (us_state_id = 47 AND name = 'RICHMOND (IND CITY)' AND geo_code_county IS NULL)
      OR (us_state_id = 47 AND name = 'ROANOKE (IND CITY)' AND geo_code_county IS NULL);    
    SQL
  end

  desc 'Update Alaskan counties with geo_codes'
  task update_ak_counties_with_geo_codes: :environment do
    alaskan_counties.each do |county|
      if County.exists?(county[:id])
        County.find(county[:id]).update_column(:geo_code_county, county[:geo_code_county])
      end
    end
  end 
  
  def alaskan_counties
    [
      { id: 68, geo_code_county:  "013"},
      { id: 69, geo_code_county:  "016"},
      { id: 70, geo_code_county:  "020"},
      { id: 71, geo_code_county:  "025"},
      { id: 72, geo_code_county:  "050"},
      { id: 73, geo_code_county:  "060"},
      { id: 74, geo_code_county:  "070"},
      { id: 75, geo_code_county:  "090"},
      { id: 76, geo_code_county:  "100"},
      { id: 77, geo_code_county:  "110"},
      { id: 78, geo_code_county:  "122"},
      { id: 79, geo_code_county:  "130"},
      { id: 80, geo_code_county:  "150"},
      { id: 81, geo_code_county:  "164"},
      { id: 82, geo_code_county:  "170"},
      { id: 83, geo_code_county:  "180"},
      { id: 84, geo_code_county:  "185"},
      { id: 85, geo_code_county:  "188"},
      { id: 86, geo_code_county:  "201"},
      { id: 87, geo_code_county:  "220"},
      { id: 88, geo_code_county:  "230"},
      { id: 89, geo_code_county:  "232"},
      { id: 90, geo_code_county:  "240"},
      { id: 91, geo_code_county:  "261"},
      { id: 92, geo_code_county:  "270"},
      { id: 93, geo_code_county:  "275"},
      { id: 94, geo_code_county:  "280"},
      { id: 95, geo_code_county:  "282"},
      { id: 96, geo_code_county:  "290"}
    ]
  end

end