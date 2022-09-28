class LesseeAndColesseeSwapper
  def initialize(lease_application: )
    @application = lease_application
  end

  def swap!
    return false unless can_swap?
    application.update(lessee_id: application.colessee_id, colessee_id: application.lessee_id)
  end

  attr_reader :application

  private

  def can_swap?
    application.lessee_id.present? && application.colessee_id.present?
  end
end
