class Admins::AuditDecorator < Draper::Decorator
  decorates :audit

  delegate_all

  def user
    return 'System' if model.user_id.nil?
    object.user
  end

  def created_at
    object.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%m/%d/%Y %r')
  end

  def created_at_ui_format
    object.created_at.in_time_zone.strftime('%b %-d, %Y at %I:%M %p %Z')
  end

  def audited_changes
    object.audited_changes&.html_safe
  end

  def self.wrap(collection)
    collection.map { |item| new(item) }
  end
end
