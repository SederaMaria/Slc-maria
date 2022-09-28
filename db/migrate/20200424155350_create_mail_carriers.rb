class CreateMailCarriers < ActiveRecord::Migration[5.1]
  def change
    create_table :mail_carriers do |t|
      t.string :description
      t.boolean :active, dafault: true

      t.timestamps
    end
  end
end
