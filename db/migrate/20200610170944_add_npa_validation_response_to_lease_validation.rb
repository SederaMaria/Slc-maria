class AddNpaValidationResponseToLeaseValidation < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_validations, :npa_validation_response, :jsonb, :null => false, :default => {}
  end
end
