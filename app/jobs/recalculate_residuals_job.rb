class RecalculateResidualsJob < ApplicationJob
  queue_as :default

  def perform(model_year_id:)
    LeaseCalculator::TERMS.each do |term|
      model_year(model_year_id).public_send(residual_attribute(term: term), new_residual_value(term: term))
    end
    model_year.save
  end

  def model_year(model_year_id = 0)
    @model_year ||= ModelYear.find(model_year_id)
  end

  def app_settings
    @app_settings ||= model_year.make.application_setting
  end

  def reduction_percentage(term:)
    app_settings.public_send("residual_reduction_percentage_#{term}".to_sym)
  end

  def residual_attribute(term:)
    "residual_#{term}=".to_sym
  end

  def new_residual_value(term:)
    Calculators::ResidualCalculator.new(
      nada_rough_value: model_year.nada_rough,
      residual_reduction_percentage: reduction_percentage(term: term),
      model_group_reduction_percentage: model_year.residual_reduction_percentage
    ).residual_value
  end

end
