namespace :admin_user_security_role do

  desc 'Migrate security role assignments from admin_users to admin_user_security_role'
  task seed: :environment do
    if AdminUserSecurityRole.all.empty?
      AdminUser.all.each do |a|
        if a.security_role_id
          AdminUserSecurityRole.create({admin_user_id: a.id, security_role_id: a.security_role_id})
        end
      end
    end
  end

end