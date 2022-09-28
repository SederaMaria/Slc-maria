namespace :admin_user do
  # bundle exec rake cities:import
  task delete: :environment do 
  	email_ids = ['paul.miller@piconbay.com', 'paul.r.miller1@gmail.com', 'paul.r.miller1+1104@gmail.com']
    users = AdminUser.where(email: email_ids)
    users.each do |user|
    	puts "Deleting User #{user.first_name} #{user.last_name}(#{user.email})"
    	user.destroy
    end
  end
end