class LeaseApplicationPaymentLimit < ApplicationRecord
  belongs_to :lease_application
  belongs_to :credit_tier

  # Monetize all `_cents` fields with a couple of lines
  if table_exists? # Fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col, allow_nil: true) if col.ends_with?('_cents') }
  end
end
