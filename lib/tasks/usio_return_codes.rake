namespace :usio_return_codes do
  desc 'Seed'
  task seed: :environment do
    if UsioReturnCode.all.empty?
      usio_return_code_seed_val.each do |usio|
        UsioReturnCode.create(usio)
      end
    end
    
  end

  def usio_return_code_seed_val
    [
      { code: 'XXX',	description: 'Transaction Not accepted. See Error Message' },
      { code: '1912',	description: 'Duplicate Transaction' },
      { code: '1100',	description: 'Account and Routing number are in the negative accounts table' }
    ]
  end
end
