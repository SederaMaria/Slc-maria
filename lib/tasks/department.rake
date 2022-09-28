namespace :department do
  desc 'Seed Department'
  task seed: :environment do
    if Department.all.empty?
      department_seed.each do |ds|
        Department.create(ds)
      end
    end
    
  end

  desc 'Patch default value to sales'
  task patch_default: :environment do
    unless lease_applications_from_w_call.empty?
      lease_applications_from_w_call.each do |app|
        if app.department_id.nil?
          app.update_column(:department_id, 1)  
        end
      end
    end
  end
  
  
  def lease_applications_from_w_call
    LeaseApplication.where(id: LeaseApplicationWelcomeCall.all.pluck(:lease_application_id).uniq).limit(nil)
  end


  def department_seed
    [
      { active: true,	description: "Sales" },
      { active: true,	description: "Servicing" }
    ]
  end
end
