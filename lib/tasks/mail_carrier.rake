namespace :mail_carrier do
  desc 'Seed Mail Carriers'
  task seed: :environment do
    if MailCarrier.all.empty?
      mail_carriers.each do |carrier|
        MailCarrier.create(carrier)
      end
    end
  end
  
  desc 'Seed Mail Carriers sort_index'
  task seed_sort_index: :environment do
    MailCarrier.all.each do |carrier|
      carrier.update(sort_index: carrier.id)
    end
  end

  def mail_carriers
    [
      { active: true,	description: "UPS" },
      { active: true,	description: "FedEx" },
      { active: true,	description: "USPS" },
      { active: true,	description: "Hand Delivered" }
    ]
  end
end
