class CreateIncomeVerificationTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :income_verification_types do |t|
      t.string :income_verification_name
      # t.timestamps
    end
  end
end
