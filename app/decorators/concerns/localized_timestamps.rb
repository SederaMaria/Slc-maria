module LocalizedTimestamps
  TIME_FORMAT = '%B %-d %Y at %l:%M %p %Z'.freeze
  EASTERN_TIME_ZONE_STRING = 'Eastern Time (US & Canada)'.freeze

  private

  def localize_timestamp(attribute:, time_zone: EASTERN_TIME_ZONE_STRING, format: TIME_FORMAT)
    I18n.localize(
        object.send(attribute.to_sym).in_time_zone(time_zone),
        format: format
    ).squish
  end

  def localize_date(attribute:, format: :default)
    if object.send(attribute.to_sym).present?
      I18n.localize( object.send(attribute.to_sym), format: format ).squish
    end
  end
end
