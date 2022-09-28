require 'rspec/core'
require 'rspec/matchers'

RSpec::Matchers.define :be_simple_audited do
  # check to see if the model has `simple_audit` declared on it
  match { |actual| actual.class.included_modules.include?(SimpleAudit::Model) }
end