class DetectRelatedApplicationsJob
  include Sidekiq::Worker

  def perform(lease_application_id)
    @origin_app  = LeaseApplication.find(lease_application_id)

    origin_app.related_applications.destroy_all if origin_app.related_applications.present?
    related_applications.each do |app|
      store_as_related_application(app)
    end
  end

  attr_reader :origin_app

  def related_applications
    results = LeaseApplication.where.not(id: origin_app.id).by_lessee_ssn(origin_app.lessee&.ssn)
    results += LeaseApplication.where.not(id: origin_app.id).by_lessee_ssn(origin_app.colessee&.ssn) if origin_app.colessee&.ssn
    results
  end

  def store_as_related_application(app)
    return true if staging_server_limit_reached?

    origin_app.related_applications.create(related_application: app)
  end

  def staging_server_limit_reached?
    return false unless on_staging_server?
    origin_app.related_applications.count > 10
  end

  def on_staging_server?
    ENV['HEROKU_APP_NAME']&.include?('staging')
  end
end
