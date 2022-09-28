namespace :welcome_call_status_169637670 do
  desc 'Seed Welcome Call Type'
  task seed: :environment do
    if WelcomeCallStatus.all.empty?
      status_seed.each do |ds|
        WelcomeCallStatus.create(ds)
      end
    end
    
  end
  
  def status_seed
    [
      { active: true,	description: "Complete" },
      { active: true,	description: "Not Complete" },
      { active: true,	description: "Representative notified" }
    ]
  end
end
