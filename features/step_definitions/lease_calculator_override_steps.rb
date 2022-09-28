
### CALCULATION STUBS, ONLY USE FOR DEBUGGING PLEASE ###
Given(/^a Base Monthly Payment of \$(\d+\.\d{2})$/) do |amount|
  Rails.logger.info("Stubbed Base Monthly Payment...")
  allow(@lease_calculator).to receive(:base_monthly_payment) { amount.to_money }
end

Given(/^a Adjusted Capitalized Cost of \$(\d+\.\d{2})$/) do |amount|
  Rails.logger.info("Stubbed Adjusted Cap Cost...")
  allow(@lease_calculator).to receive(:adjusted_capitalized_cost) { amount.to_money }
end