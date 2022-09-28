namespace :dealer_representative do
    
    desc 'Load Admin id to dealer_representatives.'
    task load: :environment do
      unless DealerRepresentative.all.empty?
        DealerRepresentative.all.limit(nil).each do |rep|
          admin = AdminUser.find_by(email: rep.email)
          if admin.present?
            rep.admin_user = admin
            rep.save
          end
        end
      end
    end
  
  end
  