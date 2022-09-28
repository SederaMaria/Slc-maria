class AdminUserDecorator < Draper::Decorator
  delegate_all

  def display_name
    "#{object&.last_name}, #{object&.first_name} (ADMIN)"
  end
end
