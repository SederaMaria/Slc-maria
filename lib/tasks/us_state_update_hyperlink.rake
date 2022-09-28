namespace :us_state_update_hyperlink do
  desc "Adds Data"

  task :update_us_states => :environment do
    UsState.where(name: 'georgia').each do |t|
      t.update_attribute :hyperlink, 'https://eservices.drives.ga.gov/?Link=TAVTEst'
      t.update_attribute :label_text, 'Tax Amount from Georgia Drives'
    end
  end
end