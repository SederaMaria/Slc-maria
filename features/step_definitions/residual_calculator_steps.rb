Given(/^a Residual Calculator$/) do
  #sets everything to 0, no nil errors and will just allow for invalid
  #calculations which will manifest in failing tests
  @residual_calculator = Calculators::ResidualCalculator.new({
    nada_rough_value:                 Money.zero,
    residual_reduction_percentage:    0.0,
    model_group_reduction_percentage: 0.0
  })
end

Given(/^a NADA rough value of (\d+)%$/) do |amount|
  @residual_calculator.nada_rough_value = amount.to_money
end

Given(/^a Residual Reduction Percentage of (\d+)%$/) do |percentage|
  @residual_calculator.residual_reduction_percentage = percentage.to_f
end

Given(/^a Model Group Reduction Percentage of (\d+)%$/) do |percentage|
  @residual_calculator.model_group_reduction_percentage = percentage.to_f
end

Then(/^residual value should be (\d+)%$/) do |expected_value|
  expect(@residual_calculator.residual_value.to_i).to eq(expected_value)
end
