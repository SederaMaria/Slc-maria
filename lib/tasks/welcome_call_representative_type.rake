namespace :welcome_call_representative_type_169637670 do
  desc 'Seed Welcome Call Representative Type'
  task seed: :environment do
    if WelcomeCallRepresentativeType.all.empty?
      representative_type_seed.each do |ds|
        WelcomeCallRepresentativeType.create(ds)
      end
    end
    
  end
  
  def representative_type_seed
    [
      { active: true,	description: "Admin User" },
      { active: true,	description: "Dealer Representative" }
    ]
  end
end