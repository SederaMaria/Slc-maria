namespace :upcase do
  task lessee_and_address: :environment do
    Rake::Task['upcase:lessee'].invoke
    Rake::Task['upcase:address'].invoke
  end

  task lessee: :environment do
    Rails.logger.info 'running to uppercase script on lessees'

    columns_to_update = update_builder(Lessee::ATTRIBUTES_TO_UPCASE)
    Lessee.connection.execute("UPDATE lessees SET #{columns_to_update.join(', ')}")

    Rails.logger.info 'done running to uppercase script on lessees'
  end

  task address: :environment do
    Rails.logger.info 'running to uppercase script on addresses'

    columns_to_update = update_builder(Address::ATTRIBUTES_TO_UPCASE)
    Address.connection.execute("UPDATE addresses SET #{columns_to_update.join(', ')}")

    Rails.logger.info 'done running to uppercase script on addresses'
  end

  def update_builder(columns)
    columns.collect do |key|
      "#{key}=upper(#{key})"
    end
  end
end
