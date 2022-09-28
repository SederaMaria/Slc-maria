namespace :passwords do
  desc 'Reset and Reuse an Old Admin Portal Password (DEVELOPERS ONLY); supply EMAIL and PASSWORD ENV variables'
  task :reset_and_reuse => :environment do
    if user = AdminUser.find_by_email(ENV['EMAIL'])
      5.times do |i|
        user.password = "P@ssw0rd!#{i}"
        user.save
      end
      user.password = ENV['PASSWORD']
      user.save
    end
  end
end