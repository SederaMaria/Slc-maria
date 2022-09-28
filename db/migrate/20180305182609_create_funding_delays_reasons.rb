class CreateFundingDelaysReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :funding_delay_reasons do |t|
      t.string :reason

      t.timestamps
    end
  end
end
