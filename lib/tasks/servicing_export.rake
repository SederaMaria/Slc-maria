namespace :servicing_export do

desc 'Generate export for servicing'
  task generate: :environment do
    applications = LeaseApplication.where(document_status: "funded")
    puts "Total Records #{applications.count}"
    CSV.open("servicing_export.csv","w", col_sep: '|') do |row|
      puts 'Inside  File Block'
      row << %w{lease_number first_name last_name dob ssn emailaddress home_phone_number mobile_phone_number} 
      
      applications.find_each do |la|
        row << [la.application_identifier, la.lessee&.first_name, la.lessee&.last_name, la.lessee&.date_of_birth, la.lessee&.ssn, la.lessee&.email_address, la.lessee&.home_phone_number, la.lessee&.mobile_phone_number]
      end
    end
  end
end