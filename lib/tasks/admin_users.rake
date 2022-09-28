namespace :admin_users do

    desc 'Change the flag of Admin users'
    task update: :environment do
      AdminUser.all.each do |user|
        if(user.is_active == true)
          user.update_attribute :is_active, 'false'
        else
          user.update_attribute :is_active, 'true'
        end
      end
    end

    desc 'Expire all tokens'
    task expire_tokens: :environment do 
      AdminUser.find_each do |u|
        u.update(auth_token: nil)
      end
    end

end