Given("a Lease Calculator") do
  #sets everything to 0, no nil errors and will just allow for invalid
  #calculations which will manifest in failing tests
  @lease_calculator = Calculators::LeaseCalculator.new({
    nada_retail_value: Money.zero,
    customer_purchase_option: Money.zero,
    dealer_sales_price: Money.zero,
    dealer_freight_and_setup: Money.zero,
    title_license_and_lien_fee: Money.zero,
    dealer_documentation_fee: Money.zero,
    guaranteed_auto_protection_cost: Money.zero,
    prepaid_maintenance_cost: Money.zero,
    extended_service_contract_cost: Money.zero,
    tire_and_wheel_contract_cost: Money.zero,
    gps_cost: Money.zero,
    gross_trade_in_allowance: Money.zero,
    trade_in_payoff: Money.zero,
    dealer_participation_markup: 0.0,
    rebates_and_noncash_credits: Money.zero,
    cash_down_payment: Money.zero,
    acquisition_fee: Money.zero,
    term: 24,
    maximum_fi_advance_percentage: 0.0,
    state_upfront_tax_percentage: 0.0,
    county_upfront_tax_percentage: 0.0,
    annual_yield: 0.0,
    sales_tax_percentage: 0.0,
    backend_advance_minimum: Money.zero,
    base_servicing_fee: Money.zero,
    enable_security_deposit: false,
    security_deposit: 1234.0
  })
  # @setting = CommonApplicationSetting.create(
  #   enable_global_security_deposit: false,
  #   global_security_deposit: 1234.0
  # )
end

Given("the Base Servicing Fee is ${float}") do |amount|
  @lease_calculator.base_servicing_fee = amount.to_money
end

Given('global security deposit is enabled') do
  # @setting.update_attribute(:enable_global_security_deposit, true)
  @lease_calculator.enable_security_deposit = true
end

Given("a NADA retail value of ${float}") do |amount|
  @lease_calculator.nada_retail_value = amount.to_money
end

Given("a customer purchase option of ${float}") do |amount|
  @lease_calculator.customer_purchase_option = amount.to_money
end

Given("a dealer sales price of ${float}") do |amount|
  @lease_calculator.dealer_sales_price = amount.to_money
end

Given("a cash down payment of ${float}") do |amount|
  @lease_calculator.cash_down_payment = amount.to_money
end

Given("a term of {int} months") do |number_of_months|
  @lease_calculator.term = number_of_months
end

Given("an annual yield of {float}%") do |percentage|
  @lease_calculator.annual_yield = percentage
end

Given("a Monthly Sales Tax Rate of {float}%") do |percentage|
  @lease_calculator.sales_tax_percentage = percentage
end

Given("an Acquisition Fee of ${float}") do |amount|
  @lease_calculator.acquisition_fee = amount.to_money
end

Given("Dealer Freight is ${float}") do |amount|
  @lease_calculator.dealer_freight_and_setup = amount.to_money
end

Given("Title, Registration, and Lien is ${float}") do |amount|
  @lease_calculator.title_license_and_lien_fee = amount.to_money
end

Given("Documentation Fee is ${float}") do |amount|
  @lease_calculator.dealer_documentation_fee = amount.to_money
end

Given("a credit tier maximum backend advance of {int}%") do |percentage|
  @lease_calculator.maximum_backend_percentage = percentage.to_f
end

Given("a backend advance minimum of ${float}") do |amount|
  @lease_calculator.backend_advance_minimum = amount.to_money
end

Given(/^a state tax rate of {int}%$/) do |percentage|
  @lease_calculator.state_tax_rate = (percentage.to_f / 100.0)
end

Given("a Trade\-in Allowance of ${float}") do |amount|
  @lease_calculator.gross_trade_in_allowance = amount.to_money
end

Given("a Trade\-in Payoff of ${float}") do |amount|
  @lease_calculator.trade_in_payoff = amount.to_money
end

Given("a dealer participation of {float}%") do |percentage|
  @lease_calculator.dealer_participation_markup = percentage
end

Given("Dealer Participation Sharing is {float}%") do |percentage|
  @lease_calculator.dealer_participation_sharing_percentage = percentage
end

Then(/^"([^"]*)" should be \$(-?\d+\.\d+)$/) do |attribute, expected_value|
  expect(@lease_calculator.send(attribute.parameterize.underscore).to_s).to eq(expected_value)
end

Given("a sales tax percentage of {float}%") do |percentage|
  @lease_calculator.sales_tax_percentage = percentage
end

Then("the monthly yield should be {float}%") do |percentage|
  expect((@lease_calculator.monthly_yield * 100.0).round(14)).to eq(percentage.to_d)
end

Given("GAP Insurance is ${float}") do |amount|
  @lease_calculator.guaranteed_auto_protection_cost = amount.to_money
end

Given("a total backend amount of ${float}") do |amount|
  @lease_calculator.guaranteed_auto_protection_cost = amount.to_money
end

Given("Prepaid Maintenance is ${float}") do |amount|
  @lease_calculator.prepaid_maintenance_cost = amount.to_money
end

Given("Extended Service Contract is ${float}") do |amount|
  @lease_calculator.extended_service_contract_cost = amount.to_money
end

Given("Tire & Wheel Warranty is ${float}") do |amount|
  @lease_calculator.tire_and_wheel_contract_cost = amount.to_money
end

Given("GPS is ${float}") do |amount|
  @lease_calculator.gps_cost = amount.to_money
end

Given("a Minimum Dealer Participation of ${float}") do |amount|
  @lease_calculator.minimum_dealer_participation = amount.to_money
end

Given("a maximum frontend advance percentage of {float}%") do |percentage|
  @lease_calculator.maximum_fi_advance_percentage = percentage.to_f
end

Given("a frontend advance haircut of {float}%") do |percentage|
  @lease_calculator.max_frontend_advance_haircut = percentage.to_f
end
