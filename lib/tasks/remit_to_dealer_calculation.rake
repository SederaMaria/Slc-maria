namespace :remit_to_dealer_calculation do
    desc 'Seed Remit to dealer calculation'
    task :seed => :environment do
        if RemitToDealerCalculation.all.empty?
            remit_to_dealer_data.each do |remit|
                RemitToDealerCalculation.create(remit)
            end
        end
    end

    private 
    def remit_to_dealer_data
        [
            {calculation_name: 'SLC Standard Lease', description: 'Standard SLC lease remit-to-dealer calculation'},
            {calculation_name: 'SLC Partner Lease', description: 'remit-to-dealer calculation used for SLC partner dealerships'}
        ]
    end
  end