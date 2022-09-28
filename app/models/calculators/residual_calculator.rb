module Calculators
  class ResidualCalculator < LdstudiosRubyCalculator::Base

    attr_accessor :nada_rough_value, :residual_reduction_percentage,
      :model_group_reduction_percentage

    calculate(:residual_value) do
      nada_rough_value.to_money *
      model_group_reduction_rate *
      residual_reduction_rate
    end

    calculate(:model_group_reduction_rate) do
      model_group_reduction_percentage / 100.0
    end

    calculate(:residual_reduction_rate) do
      residual_reduction_percentage / 100.0
    end
  end
end
