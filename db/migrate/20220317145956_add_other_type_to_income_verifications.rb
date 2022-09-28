class AddOtherTypeToIncomeVerifications < ActiveRecord::Migration[6.0]
  def change
    add_column :income_verifications, :other_type, :string
  end
end
