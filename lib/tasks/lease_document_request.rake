namespace :lease_document_request do

  desc 'Conevert VIN to UPPERCASE'
  task uppercase_vin: :environment do
    LeaseDocumentRequest.update_all('asset_vin = upper(asset_vin)')
  end

  desc 'Change Indian Motorcycles to Indian Motorcyle'
  task change_indian_name: :environment do
    LeaseDocumentRequest.where(asset_make: 'Indian Motorcycles').update_all(asset_make: 'Indian Motorcycle')
  end

end
