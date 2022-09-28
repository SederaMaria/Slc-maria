class String
  def to_boolean
    ActiveRecord::Type::Boolean.new.cast(self)
  end
end

namespace :model_years do
  # bundle exec rake model_years:import
   desc "Import Nada_Model_Number and police_bike from Excel"
   task import: :environment do 
     doc = Roo::Spreadsheet.open('db/NADA_ModelNum_Update.xlsx', extension: :xlsx)
     doc.each do |row|
      modelyearsobj = ModelYear.where(id: row[0]).first
      if modelyearsobj.present?
        modelyearsobj.nada_model_number = row[3]
        modelyearsobj.police_bike = row[4].to_boolean
        # puts row[4].class
        if modelyearsobj.save!
          puts "Successfully updated ModelYear record for id: #{row[0]}"
        else
          puts "Failed to update ModelYear record for id: #{row[0]}"
        end  
      else
         puts "Record not found for id: #{row[0]}"     
      end   
    end
  end
end
