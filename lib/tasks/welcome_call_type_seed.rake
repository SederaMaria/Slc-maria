namespace :welcome_call_type_169637670 do
  desc 'Seed Welcome Call Type'
  task seed: :environment do
    if WelcomeCallType.all.empty?
      type_seed.each do |ds|
        WelcomeCallType.create(ds)
      end
    end
    
  end
  
  def type_seed
    [
      { active: true,	description: "Outbound call" },
      { active: true,	description: "Inbound call" }
    ]
  end
end
