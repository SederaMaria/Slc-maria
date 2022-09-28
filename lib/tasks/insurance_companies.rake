namespace :insurance_companies do
    desc "Importing data for insurance companies"
    task import: :environment do
    InsuranceCompany.delete_all
    companies.each do |company|
    unless InsuranceCompany.exists?(company_name: company[0])
        InsuranceCompany.create(
           company_name:         company[0],
           company_code:         company[1]
         )
     p company
      end
    end
  end
    
    def companies
      xlsx = Roo::Spreadsheet.open('db/insurance_company.xlsx', extension: :xlsx)
      a = []
      b = 0
      ids = xlsx.column(1)
      access_id = xlsx.column(2)
      
      ids.each do |id|
        a << [id,access_id[b]]
        b += 1
      end
      return a.drop(1)
     end
    end
      