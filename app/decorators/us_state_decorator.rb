class UsStateDecorator < Draper::Decorator
  decorates :us_state
  delegate_all

  def name
    object.name.titleize
  end
end
