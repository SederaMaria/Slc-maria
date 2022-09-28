Given("a Gross Trade\-in Allowance of ${float}") do |amount|
  @lease_calculator.gross_trade_in_allowance = amount.to_money
end

Given("a Cash Down Payment of ${float}") do |amount|
  @lease_calculator.cash_down_payment = amount.to_money
end

Given("a Dealer Sales Price of ${float}") do |amount|
  @lease_calculator.dealer_sales_price = amount.to_money
end

Given("a Dealer Freight and Setup Fee of ${float}") do |amount|
  @lease_calculator.dealer_freight_and_setup = amount.to_money
end

Given("the Documentation Fee is ${float}") do |amount|
  @lease_calculator.dealer_documentation_fee = amount.to_money
end

Given("a GA TAVT Value of ${float}") do |amount|
  @lease_calculator.ga_tavt_value = amount.to_money
end

Given(/^the Lessee Resides in "([^"]*)"$/) do |state|
  @lease_calculator.lessee_state = state
end

Given("a State Upfront Tax Percentage of {float}%") do |percentage|
  @lease_calculator.state_upfront_tax_percentage = percentage.to_f
end

Given("a County Upfront Tax Percentage of {float}%") do |percentage|
  @lease_calculator.county_upfront_tax_percentage = percentage.to_f
end

Given("a Local Upfront Tax Percentage of {float}%") do |percentage|
  @lease_calculator.local_upfront_tax_percentage = percentage.to_f
end

Then("the Local Upfront Tax Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.local_upfront_tax).to eq(expected_value.to_money)
end

Then("the Total Upfront Tax Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax).to eq(expected_value.to_money)
end

Then("the State Upfront Tax Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.state_upfront_tax).to eq(expected_value.to_money)
end

Then("the County Upfront Tax Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.county_upfront_tax).to eq(expected_value.to_money)
end

Then("the State Single Item Tax Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.state_single_item_tax).to eq(expected_value.to_money)
end

Then("the County Single Item Tax Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.county_single_item_tax).to eq(expected_value.to_money)
end

Then("the SOP Depreciation Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.monthly_depreciation_charge).to eq(expected_value.to_money)
end

Then("the SOP Lease Charge Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.monthly_lease_charge).to eq(expected_value.to_money)
end

Then("the SOP Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.pre_tax_payments_sum).to eq(expected_value.to_money)
end

Then("the SOP Tax On Payments Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.tax_on_payments).to eq(expected_value.to_money)
end

Then("the SOP Tax On Cash Amount should be ${float}") do |expected_value|
  expect(@lease_calculator.upfront_tax_calculator.tax_on_cash_and_trade_allowance).to eq(expected_value.to_money)
end


