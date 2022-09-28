class Admins::LeaseApplicationStipulationDecorator < Draper::Decorator
  decorates :lease_application_stipulation

  delegate_all

  def attachment_url
    attachment&.upload&.url
  end

  def attachment_filename
    attachment&.read_attribute(:upload)
  end

  def attachment
    return if object.lease_application_attachment_id.blank?
    object.lease_application_attachment
  end

  def self.wrap(collection)
    collection.map { |item| new(item) }
  end
end