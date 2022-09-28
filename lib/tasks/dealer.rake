namespace :db do
    desc "We don't want to expose real customer data on staging server"
  
    task :disable_dealers => :environment do
        Dealer.find_each do |l|
            if !l.email.include?("speedleasing.com")
            puts "Disabling Dealer... #{l.id}"
            l.update(is_disabled: true)
            end  
        end
    end
end