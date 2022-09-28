namespace :lease_calculators do

  desc 'Change Indian Motorcycles to Indian Motorcyle'
  task change_indian_name: :environment do
    LeaseCalculator.where(asset_make: 'Indian Motorcycles').update_all(asset_make: 'Indian Motorcycle')
  end

end