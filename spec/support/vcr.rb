VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_hosts '127.0.0.1', 'localhost', '0.0.0.0', 'chromedriver.storage.googleapis.com'
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options = {record: :new_episodes, :match_requests_on=>[:host, :path]}
  #c.debug_logger = $stderr
end