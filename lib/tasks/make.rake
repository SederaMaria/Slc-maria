namespace :make do

  desc 'Change Indian Motorcycles to Indian Motorcyle'
  task change_indian_name: :environment do
    Make.where(name: 'Indian Motorcycles').update_all(name: 'Indian Motorcycle')
  end

  desc 'Update LMS abbreviations'
  task change_lms_manf: :environment do 
    Make.where(lms_manf: 'HARLEY-DAV').update_all(lms_manf: 'H-D')
    Make.where(lms_manf: 'INDIAN').update_all(lms_manf: 'Indian')
  end

end