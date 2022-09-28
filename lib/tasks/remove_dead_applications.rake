namespace :maintenance do
  desc 'Delete lease applications that are more than 30 days old, that have a calculator, and are missing lessee details'
  task remove_dead_applications: :environment do
    Rails.logger.info 'Removing dead applications.'
    RemoveDeadApplications.call
  end
end
