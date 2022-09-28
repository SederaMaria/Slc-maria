class DealerDecorator < Draper::Decorator
  delegate_all

  def display_name
    "#{object&.last_name}, #{object&.first_name} (#{object&.dealership_name})"
  end
end
