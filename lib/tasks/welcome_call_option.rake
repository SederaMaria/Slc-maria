namespace :welcome_call_result_169637670 do
  desc 'Seed Welcome Call Result'
  task seed: :environment do
    if WelcomeCallResult.all.empty?
      option_seed.each do |ds|
        WelcomeCallResult.create(ds)
      end
    end
    
  end

  desc 'Adding new Welcome Call Result'
  task seed_new_record: :environment do
    options = ['Sent text', 'No voicemail available', 'Reached out to dealer']
    options.each do |st|
      welcome_call_result = WelcomeCallResult.find_or_initialize_by(description: st)
      welcome_call_result.active = true
      sort_index = WelcomeCallResult.maximum(:sort_index).presence || 0
      welcome_call_result.sort_index = sort_index + 1 if welcome_call_result.new_record?
      welcome_call_result.save
    end
  end

  def option_seed
    [
      { active: true,	description: "Message left on voicemail" },
      { active: true,	description: "Message left with another party" },
      { active: true,	description: "Spoke with lessee" }
    ]
  end
end
