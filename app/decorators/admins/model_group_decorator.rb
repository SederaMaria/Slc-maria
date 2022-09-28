class Admins::ModelGroupDecorator < Draper::Decorator
  decorates :model_group

  delegate_all

  def minimum_dealer_participation
    helpers.humanized_money_with_symbol(object.minimum_dealer_participation, precision: 2)
  end

  def backend_advance_minimum
    helpers.humanized_money_with_symbol(object.backend_advance_minimum, precision: 2)
  end

  def residual_reduction_percentage
    helpers.number_to_percentage(object.residual_reduction_percentage, precision: 2)
  end
end
