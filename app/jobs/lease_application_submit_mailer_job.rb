class LeaseApplicationSubmitMailerJob
  include Sidekiq::Worker

  def perform(opts)
    opts.symbolize_keys!
    DealerMailer.application_submitted(application_id: opts[:application_id]).deliver_now    
    DealerMailer.application_submitted_dealer(application_id: opts[:application_id]).deliver_now
  end
end
