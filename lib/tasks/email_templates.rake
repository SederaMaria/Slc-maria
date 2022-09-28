namespace :email_templates do
  desc 'Seed Email templates'
  task seed: :environment do
    if EmailTemplate.all.empty?
      email_templates_seed.each do |ds|
        EmailTemplate.create(ds)
      end
    end
  end
  

  desc 'Seed Names and add rejected Blackbox email'
  task seed_blackbox: :environment do
    lease_package_recieved = EmailTemplate.first
    if lease_package_recieved
      lease_package_recieved.update(name: "Lease Package Received")
    end
    EmailTemplate.create!(template: '', name: 'Blackbox Auto Reject')
  end


  def email_templates_seed
    [
      { template: '' }
    ]
  end
end
