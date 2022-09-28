class TaxRuleDecorator < Draper::Decorator
  delegate_all


  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def sales_tax_percentage
    helpers.number_to_percentage(object.send(__method__), precision: 4)
  end

  def up_front_tax_percentage
    helpers.number_to_percentage(object.send(__method__), precision: 4)
  end

  def cash_down_tax_percentage
    helpers.number_to_percentage(object.send(__method__), precision: 4)
  end

  def rule_type
    object.rule_type.titleize
  end
end
