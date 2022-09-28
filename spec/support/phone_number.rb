RSpec.configure do |config|
  config.before(:each) do
    # this ensures that the before save twilio check won't run so we can trigger it manually
    allow_any_instance_of(Reference).to receive(:valid_phone?).and_return(false)
  end
end