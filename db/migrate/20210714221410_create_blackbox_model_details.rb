class CreateBlackboxModelDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :blackbox_model_details do |t|
      t.references :blackbox_model, foreign_key: true, index: true
      t.integer :blackbox_tier, null: false
      t.integer :credit_score_greater_than, default: 0, null: false
      t.integer :credit_score_max, default: 0, null: false
      t.decimal :irr_value, default: 0.00, precision: 8, scale: 2, null: false
      t.decimal :maximum_fi_advance_percentage, default: 0.00, precision: 4, scale: 2, null: false
      t.decimal :maximum_advance_percentage, default: 0.00, precision: 5, scale: 2, null: false
      t.decimal :required_down_payment_percentage, default: 0.00, precision: 4, scale: 2, null: false
      t.integer :security_deposit, default: 0, null: false
      t.boolean :enable_security_deposit, default: false, null: false
      t.integer :acquisition_fee_cents, default: 0, null: false
      t.decimal :payment_limit_percentage, precision: 4, scale: 2, null: false
      t.timestamps
    end
  end
end
