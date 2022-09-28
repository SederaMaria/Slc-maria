class RenameVarianceToVarianceCents < ActiveRecord::Migration[6.0]
  def change
    rename_column :lease_application_payment_limits, :variance, :variance_cents
  end
end
