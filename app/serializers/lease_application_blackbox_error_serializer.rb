class LeaseApplicationBlackboxErrorSerializer < ApplicationSerializer
  attributes :error_code, :name, :message, :failure_conditional
end
