class CreateIncomeFrequencies < ActiveRecord::Migration[6.0]
  def change
    create_table :income_frequencies do |t|
      t.string :income_frequency_name
      # t.timestamps
    end
  end
end
