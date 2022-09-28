namespace :heroku do
  desc 'Release Phase Task'
  task release: :environment do
    if ENV['HEROKU_PARENT_APP_NAME'].present? #Release apps have this configuration
      unless ActiveRecord::Base.connection.data_source_exists? 'schema_migrations'
        Rake::Task['db:structure:load'].invoke
      end
      Rake::Task['db:migrate'].invoke
    else
      Rake::Task['db:migrate'].invoke
    end
  end
end
