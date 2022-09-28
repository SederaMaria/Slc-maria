class RemainingFundingDelayJob
  include Sidekiq::Worker
  sidekiq_options unique:      :until_executed,
                  unique_args: :unique_args
                  
  def self.unique_args(args)
    funding_delay = FundingDelay.find args[0]['id']
    funding_delay.lease_application.id
  end
  
  def perform(opts)
    opts.symbolize_keys!
    @funding_delay = FundingDelay.find opts[:id]
    @lease_application = @funding_delay.lease_application
    notify_dealers
  end
  
  def notify_dealers
    if @lease_application.funding_delays.pluck(:status).include?("Required")
      dealers = @lease_application.dealership.active_dealers
      dealers.each do |dealer|     
        DealerMailer.dealer_notification(application: @lease_application, dealer: dealer, status: 'remaining_funding_delay').deliver_now
      end
    end
  end
  
end
