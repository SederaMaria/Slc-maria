class CreateBlackboxModels < ActiveRecord::Migration[6.0]
  def change
    create_table :blackbox_models do |t|
      t.string :blackbox_version, null: false
      t.date :model_date, null: false
      t.boolean :default_model, default: false, null: false
      t.timestamps
    end
  end
end
