class CreateStipulationCreditTierTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :stipulation_credit_tier_types do |t|
      t.string :description
      t.integer :position
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
  end
end
