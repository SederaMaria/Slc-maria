FactoryBot.define do
  factory :blackbox_model_detail do
    blackbox_model_id                 { 1 }
    blackbox_tier                     { 1 }
    irr_value                         { 12.00 }
    maximum_fi_advance_percentage     { 20.00 }
    maximum_advance_percentage        { 120.00 }
    required_down_payment_percentage  { 0.00 }
    security_deposit                  { 0 }
    enable_security_deposit           { false }
    acquisition_fee_cents             { 0 }
    payment_limit_percentage          { 15.00 }
  end
end
