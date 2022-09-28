class AddValidationResponseToLeaseValidations < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_validations, :validation_response, :text
  end
end
