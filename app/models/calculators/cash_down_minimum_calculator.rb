module Calculators
  class CashDownMinimumCalculator < LdstudiosRubyCalculator::Base

    attr_accessor :estimate,
                  :lease_calculator,
                  :duped_lease_calculator

    calculate(:cash_down_minimum) do
      Rails.logger.info("MINIMUM CASH CALCULATOR: comparing #{estimate} <=> #{next_estimate}")
      close_enough? ? [estimate, next_estimate].max : duped_lease_calculator.cash_down_minimum
    end

    calculate(:next_estimate) do
      duped_lease_calculator.cash_down_payment = estimate
      duped_lease_calculator.cash_down_minimum_estimate
    end

    private

    def duped_lease_calculator
      @duped_lease_calculator ||= lease_calculator.dup.clear_cached_calculations!
    end

    # Quit if we're within $1 (100 Cents)
    def close_enough?
      (-100..100).cover?( (estimate - next_estimate).fractional)
    end
  end
end
