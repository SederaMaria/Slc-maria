class FundingRequestFormJob
  include Sidekiq::Worker
  sidekiq_options unique:      :until_executed

  def perform(lease_id, is_revised)
    FundingRequestFormService.new(lease_id: lease_id, is_revised: is_revised).call
  end
  
end