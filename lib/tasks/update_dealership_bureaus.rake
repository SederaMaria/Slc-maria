namespace :update_deaership_bureaus_los_33 do
  desc 'Update Dealership bureaus'
  task update: :environment do
    unless active_dealerships.empty?
      active_dealerships.update_all(use_transunion: true, use_experian: true, use_equifax: true)
    end
  end
  
  def active_dealerships
    Dealership.all.where(active: true)
  end
end
