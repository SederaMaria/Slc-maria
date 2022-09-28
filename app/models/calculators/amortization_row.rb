module Calculators
  class AmortizationRow < LdstudiosRubyCalculator::Base
    attr_accessor :starting_balance, :monthly_yield, :pretax_payment
  
    #INTEREST
    calculate(:rent_charge) do
      (starting_balance.exchange_to(:us8) * monthly_yield).exchange_to(:usd)
    end

    #PRINCIPLE
    calculate(:depreciation) do
      pretax_payment - rent_charge
    end

    calculate(:ending_balance) do
      starting_balance - depreciation
    end
  end
end
