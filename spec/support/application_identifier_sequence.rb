RSpec.configure do |config|
  config.before(:suite) do
    LeaseApplication.connection.execute <<-SQL
      ALTER SEQUENCE next_application_identifier_seq RESTART WITH 1;
    SQL
  end
  config.after(:suite) do
    LeaseApplication.connection.execute <<-SQL
      ALTER SEQUENCE next_application_identifier_seq RESTART WITH 1;
    SQL
  end
end