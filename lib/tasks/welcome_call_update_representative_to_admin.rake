namespace :welcome_call_update_representative_to_admin_170480957 do
  desc 'Update Welcome Call representatives to admin'
  task update: :environment do
    unless welcome_call_representatives.empty?
      welcome_call_representatives.each do |wcr|
        if representative_exits?(wcr.admin_id)
          rep = get_representative(wcr.admin_id)
          if admin_exists?(rep.email)
            wcr.update_attribute :admin_id, get_admin(rep.email).id
          end
        end
      end
    end
    
  end
  
  def welcome_call_representatives
    LeaseApplicationWelcomeCall.where(welcome_call_representative_type_id: 2)
  end
  
  def get_representative(id)
    DealerRepresentative.find(id)
  end
  
  def representative_exits?(id)
    DealerRepresentative.exists?(id)
  end
  
  def admin_exists?(email)
    AdminUser.exists?(email: email)
  end
  
  def get_admin(email)
    AdminUser.find_by(email: email)
  end

end
