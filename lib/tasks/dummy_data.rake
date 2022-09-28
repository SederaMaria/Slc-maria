namespace :dummy_data do
  desc "We don't want to expose real customer data on staging server"
  task create_test_data: :environment do
    Lessee.find_each do |l|
      puts "Updating Lessee #{l.id}"
      if (l.id > 14836)
      l.update(first_name: FFaker::Name.first_name,
                          middle_name: FFaker::Name.first_name,
                          last_name: FFaker::Name.last_name,
                          ssn: FFaker::SSN.ssn,
                          date_of_birth: Random.new.rand(18..100).years.ago,
                          employment_details: 'Gainfully employed at Speed Leasing',
                          employer_name: 'Speed Leasing',
                          highest_fico_score: '720',
                          email_address: 'billy@example.com')
      end

    end

    Address.find_each do |a|
      puts "Updating Address #{a.id}"
      a.update(street1: FFaker::Address.street_name,
                          street2: "Unit #{Random.new.rand(1..1000)}",
                          city: FFaker::Address.city,
                          state: FFaker::Address.us_state,
                          zipcode: FFaker::Address.zip_code)
    end
  end
end