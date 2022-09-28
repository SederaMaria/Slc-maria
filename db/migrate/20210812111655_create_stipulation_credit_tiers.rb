class CreateStipulationCreditTiers < ActiveRecord::Migration[6.0]
  def change
    create_table :stipulation_credit_tiers do |t|
      t.references :stipulation_credit_tier_type, index: { name: 'index_sctt_on_sitpulation_credit_tier' }
      t.references :stipulation, index: { name: 'index_s_on_sitpulation_credit_tier' }
      t.timestamps
    end
  end
end
