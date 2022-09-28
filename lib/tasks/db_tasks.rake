namespace :db do
  desc 'Clears database of sensitive information'
  task clear_sensitive_fields: :environment do
    #return if Rails.env.production?
    #Set all Social Security Numbers to a dummy value
    Lessee.update_all(ssn: nil, email_address: 'lessee@speedleasing.com')
    
    Lessee.find_each do |lessee|
      lessee.ssn = '133-12-1028'
      lessee.save!
    end

    Dealer.connection.execute(
      <<-SQL
        UPDATE dealers
          SET email = 'slc-dealer' || dealers.id || '@speedleasing.com'
          WHERE dealers.dealership_id <> (SELECT id from dealerships where name = 'Speed Leasing (ADMIN ACCOUNT)' LIMIT 1)
      SQL
    )
    InboundContact.update_all(email: 'InboundContact@speedleasing.com')
  end

  desc 'Erase Empty Colessee Records'
  task erase_empty_colessees: :environment do
    colessee_ids = Lessee.all.select {|l| l.ssn.blank? && l.first_name.blank? }.pluck(:id) - LeaseApplication.pluck(:lessee_id)
    LeaseApplication.where(colessee_id: colessee_ids).update_all(colessee_id: nil)
    Lessee.destroy(colessee_ids)
  end

  desc "Update current city tables mapped through the new xlx filw"
  task update_cities: :environment do
    doc = Roo::Spreadsheet.open('db/cities.xlsx')
    doc.each do |row|
      # row[0] => geo_state
      # row[1] => geo_county
      # row[2] => geo_city
      # row[3] => us_state_id
      # row[4] => name
      # row[5] => city_zip_begin
      # row[6] => city_zip_end
      unless row[4] == "name"
        state           = row[0]
        county          = row[1]
        city            = row[2]
        us_state_id     = row[3]
        name            = row[4]
        city_zip_begin  = row[5]
        city_zip_end    = row[6]
        puts "********************************************* Cities Attributes Start ********************** "
        puts "state: #{state}"
        puts "county: #{county}"
        puts "city: #{city}"
        puts "name: #{name}"
        puts "city_zip_begin: #{city_zip_begin}"
        puts "city_zip_end: #{city_zip_end}"
        puts "********************************************* Cities Attributes End ********************** "
        name.present? && City.create(geo_state: state, geo_county: county, geo_city: city, name: name, city_zip_begin: city_zip_begin, city_zip_end: city_zip_end)
      end
    end
  end
end
