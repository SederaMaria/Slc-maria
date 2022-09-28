class CreateDeclineReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :decline_reasons do |t|
      t.string :description
      t.references :lease_application, index: true

      t.timestamps
    end
  end
end
