class CreateApplicationSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :application_settings do |t|
      t.integer :high_model_year, default: 2017, null: false
      t.integer :low_model_year, default: 2007, null: false
    end
  end
end
