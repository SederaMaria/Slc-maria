namespace :cities do
  # bundle exec rake cities:import
  task import: :environment do 
    service = UpdateCitiesService.new
    service.call
  end

  desc 'Delete six duplicate city records'
  task delete_six_duplicate_city_records: :environment do
  	ActiveRecord::Base.connection.execute(<<-SQL)
  		DELETE FROM cities WHERE ID IN(12309, 12938, 40419, 40421, 40529, 40537);
  	SQL
  end
end