class EmailValidator
  attr_reader :email
  attr_reader :client

  def initialize(email)
    @email = email
    api_key = ENV['KICKBOX_API_KEY']
    @client = Kickbox::Client.new(api_key).kickbox
  end

  def call
    result = client.verify(email).body
    result["result"] == 'deliverable' && result["reason"] == 'accepted_email'
  end

  def valid?
    call
  end
end

