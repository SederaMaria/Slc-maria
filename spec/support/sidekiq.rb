require 'sidekiq/testing'
require 'sidekiq_unique_jobs/testing'

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end
