class RemoveDeadApplications

  def self.call(*args)
    new(*args).call
  end

  def call
    LeaseApplication.dead_applications.destroy_all
  end
end
