#Generates an Amortization Schedule, given the supplied Lease Calculator
class AmortizationSchedule

  attr_accessor :lease_calculator, :term, :credit_tier_record
  attr_reader :pretax_payment, :schedule, :irr_value

  def initialize(lease_calculator:, credit_tier_record:)
    @lease_calculator   = lease_calculator
    @credit_tier_record = credit_tier_record
    @term               = lease_calculator.term || 24
    @schedule           = Array.new(term)
    @pretax_payment     = lease_calculator.base_monthly_payment
    @irr_value          = credit_tier_record&.irr_value || 0.0
  end

  def can_generate?
    credit_tier_record&.irr_value
  end

  def total_rent_charge
    create_amortization_schedule if @schedule.compact.empty?
    @schedule.compact.inject(0) do |total_rent_charge, row|
      total_rent_charge += row.rent_charge
    end
  end

  def total_depreciation
    create_amortization_schedule if @schedule.compact.empty?
    @schedule.compact.inject(0) do |total_depreciation, row|
      total_depreciation += row.depreciation
    end - lease_calculator.customer_purchase_option
  end

  def create_amortization_schedule
    @schedule[0] = calculate_first_row

    2.upto(term - 1) do |period|

      @schedule[period-1] = calculate_inner_row(starting_balance: @schedule[period-2].ending_balance)
    end
    @schedule[-1] = calculate_final_row

    @schedule
  end
  alias_method :create, :create_amortization_schedule

  def calculate_first_row
    calculate_inner_row(starting_balance: initial_starting_balance)
  end

  def calculate_final_row
    calculated_inner_row = calculate_inner_row(starting_balance: @schedule[-2].ending_balance)
    OpenStruct.new({
      rent_charge: calculated_inner_row.rent_charge,
      depreciation: calculated_inner_row.depreciation + lease_calculator.customer_purchase_option,
      ending_balance: Money.zero,
      pretax_payment: calculated_inner_row.rent_charge + calculated_inner_row.depreciation + lease_calculator.customer_purchase_option
    })
  end

  def calculate_inner_row(starting_balance:)
    Calculators::AmortizationRow.new({
      starting_balance: starting_balance,
      monthly_yield: monthly_yield,
      pretax_payment: pretax_payment,
    })
  end

  def initial_starting_balance
    @initial_starting_balance ||= lease_calculator.adjusted_capitalized_cost
  end

  private

    def monthly_yield
      @monthly_yield ||= annual_yield_to_monthly(irr_value) + annual_yield_to_monthly(lease_calculator.dealer_participation_markup)
    end

    def annual_yield_to_monthly(_annual_yield)
      _annual_yield.zero? ? 0.0 : ((_annual_yield/100.0 + 1)**(1.0/12.0))-1
    end

end