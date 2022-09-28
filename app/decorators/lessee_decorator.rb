class LesseeDecorator < Draper::Decorator
  decorates :lessee
  delegate_all

  def display_name
    "#{object&.first_name} #{middle_name(object)} #{object&.last_name} #{object&.suffix}".squish
  end

  def short_name
    "#{object&.first_name.to_s[0]} #{object&.last_name.to_s[0,23]}".squish
  end  

  def middle_name(lessee)
    return '' unless lessee&.middle_name
    case lessee.middle_name.size
      when 0
        ''
      when 1
        "#{lessee.middle_name}."
      else
        lessee.middle_name
    end
  end
end
