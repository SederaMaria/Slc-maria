class LeasePackageGeneratorJob < ApplicationJob
  queue_as :default

  def perform(application_id:)
    #should I place some scopes on this to prevent improper lease package generation?
    lease_app = LeaseApplication.where(id: application_id).first
    generated_file = LeasePackageDocument.new(lease_app).generate if lease_app
  end
end