namespace :prenote_cron_job do
  desc "Cron Job for Prenote Confirmation"
  task run: :environment do
    prenote_job = PrenoteJobService.new
    prenote_job.call
  end
end
