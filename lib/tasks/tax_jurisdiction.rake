namespace :tax_jurisdiction do

  desc 'Update existing state-only Tax Jurisdiction records with geo_codes'
  task set_geocodes_existing_states: :environment do
  	ActiveRecord::Base.connection.execute(<<-SQL)
      UPDATE tax_jurisdictions AS tj
      SET 
        geo_code_state = sub.geo_code_state,
        geo_code_county = '000',
        geo_code_city = '0000',
        tax_record_types_id = 1
      FROM (
        SELECT tj.id, us.geo_code_state
        FROM tax_jurisdictions tj 
        LEFT JOIN us_states AS us ON tj.us_state = us.state_enum
        WHERE county_tax_rule_id IS NULL  
        ) AS sub
      WHERE tj.id = sub.id;
  	SQL
  end

  desc 'Insert missing state-only records for future Vertex use'
  task insert_missing_geo_code_states: :environment do
    ActiveRecord::Base.connection.execute(<<-SQL)
      WITH data AS (
        SELECT geo_code_state, '000' AS geoCodeCounty, '0000' AS geoCodeCity, 1 AS taxRecordTypeID, now() AS createdAt, now() AS updatedAt
        FROM us_states
        WHERE geo_code_state NOT IN (SELECT DISTINCT(geo_code_state) FROM tax_jurisdictions WHERE geo_code_state IS NOT NULL)
        ORDER BY geo_code_state
      )
      INSERT INTO tax_jurisdictions
      (geo_code_state, geo_code_county, geo_code_city, tax_record_types_id, created_at, updated_at)
      SELECT * FROM data;
    SQL
  end

  desc 'Set relationship to us_states table'
  task set_us_states_foreign_key: :environment do
    ActiveRecord::Base.connection.execute(<<-SQL)
      UPDATE tax_jurisdictions AS tj
      SET us_states_id = us.id
      FROM us_states AS us
      WHERE tj.geo_code_state = us.geo_code_state;
    SQL
  end

=begin    tax_jurisdiction_existing_counties.each do |record|
      if TaxJurisdiction.exists?(record[:id])
        TaxJurisdiction.find(record[:id]).update_columns(
          :geo_code_county, record[:geo_code_county],
          :tax_record_types_id, record[:tax_record_types_id],
          :us_states_id, record[:us_states_id]
          )
      end
    end
  end
=end


  desc 'Update existing Tax Jurisdiction county records with state and county geo_codes'
  task set_geocodes_existing_counties: :environment do
    puts 'Began updating tax_jurisidiction records'
    CSV.parse(tax_jurisdiction_existing_counties, headers: true) do |row|
      tax_jurisdiction = TaxJurisdiction.find(row['id'])

      if tax_jurisdiction.present?
        tax_jurisdiction.geo_code_state       = row['geo_code_state']
        tax_jurisdiction.geo_code_county      = row['geo_code_county']
        tax_jurisdiction.tax_record_types_id  = row['tax_record_types_id']
        tax_jurisdiction.us_states_id         = row['us_states_id']
        if !(tax_jurisdiction.save)
          puts "Failed to update tax_jurisdiction id: #{row['id']}"
        end
      else
        puts "Could not find tax_jurisdiction id: #{row['id']}"
      end
    end
    puts 'Completed'
  end

  def tax_jurisdiction_existing_counties
    <<-CSV
id,geo_code_state,geo_code_county,tax_record_types_id,us_states_id
4,"10","131",2,12
5,"10","111",2,12
7,"01","127",2,1
8,"10","001",2,12
9,"10","003",2,12
10,"10","005",2,12
11,"10","007",2,12
12,"10","009",2,12
13,"10","011",2,12
14,"10","013",2,12
15,"10","015",2,12
16,"10","017",2,12
17,"10","019",2,12
18,"10","021",2,12
19,"10","023",2,12
20,"10","027",2,12
21,"10","029",2,12
22,"10","031",2,12
23,"10","033",2,12
24,"10","035",2,12
25,"10","037",2,12
26,"10","039",2,12
27,"10","041",2,12
28,"10","043",2,12
29,"10","045",2,12
30,"10","047",2,12
31,"10","049",2,12
32,"10","051",2,12
33,"10","053",2,12
34,"10","055",2,12
35,"10","057",2,12
36,"10","059",2,12
37,"10","061",2,12
38,"10","063",2,12
39,"10","065",2,12
40,"10","067",2,12
41,"10","069",2,12
42,"10","071",2,12
43,"10","073",2,12
44,"10","075",2,12
45,"10","077",2,12
46,"10","079",2,12
47,"10","081",2,12
48,"10","083",2,12
49,"10","085",2,12
50,"10","025",2,12
51,"10","087",2,12
52,"10","089",2,12
53,"10","091",2,12
54,"10","093",2,12
55,"10","095",2,12
56,"10","097",2,12
57,"10","099",2,12
58,"10","101",2,12
59,"10","103",2,12
60,"10","105",2,12
61,"10","107",2,12
62,"10","109",2,12
63,"10","113",2,12
64,"10","115",2,12
65,"10","117",2,12
66,"10","119",2,12
67,"10","121",2,12
68,"10","123",2,12
69,"10","125",2,12
70,"10","127",2,12
71,"10","129",2,12
72,"10","133",2,12
6611,"39","003",2,41
6612,"39","101",2,41
    CSV
  end

end