namespace :lessee_details do

desc 'Generate export of lessee details'
  task export: :environment do
    applications = LeaseApplication.where("created_at between '#{'2019-02-01'.to_time}' and '#{'2019-06-30'.to_time}'").where.not(lessee_id: nil)
  	puts "Total Records #{applications.count}"
    CSV.open("lessee_details_export.csv","w", col_sep: '|') do |row|
      puts 'Inside  File Block'
  		row << %w{lessee_id application_identifier application_number ssn document_status credit_status} 	
    	
    	applications.find_each do |la|
    		row << [la.lessee_id, la.application_identifier, la.id, la.lessee&.ssn, la.document_status, la.credit_status]
		  end
    end
    CSV.open("tmp/lessee_details_export.csv","w", col_sep: '|') do |row|
      puts 'Inside Tmp  File Block'
      row << %w{lessee_id application_identifier application_number ssn document_status credit_status}  
      
      applications.find_each do |la|
        row << [la.lessee_id, la.application_identifier, la.id, la.lessee&.ssn, la.document_status, la.credit_status]
      end
    end
  end
end