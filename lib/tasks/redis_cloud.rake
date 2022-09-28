namespace :redis_cloud do
  desc 'Keep Redis Cloud Alive by running a Job that does not do anything'
  task :keep_alive => :environment do
    KeepAliveJob.perform_later(1..100)
  end
end