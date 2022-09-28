namespace :security_roles do
  desc 'Seed Security Roles'
  task seed: :environment do
    if SecurityRole.all.empty?
      security_seed.each do |ss|
        SecurityRole.create({description: ss})
      end
    end
  end
  
  def security_seed
    [
      'Administrator', 
      'Business Intelligence User', 
      'Executive', 
      'Sales Manager', 
      'Sales User', 
      'Servicing Manager', 
      'Servicing User', 
      'Underwriting Manager', 
      'Underwriting User', 
      'Verification Manager', 
      'Verification User'
    ]

  end


  desc 'Set if can see welcome call dashboard'
  task set_welcome_call_dashboard: :environment do
    allowedroles = ['Administrator', 'Executive', 'Sales Manager', 'Sales User', 'Servicing Manager', 'Underwriting Manager', 'Verification Manager']
    unless SecurityRole.all.empty?
      SecurityRole.where(description: allowedroles).each do |admin|
        admin.can_see_welcome_call_dashboard = true
        admin.save
      end
    end
  end

end
