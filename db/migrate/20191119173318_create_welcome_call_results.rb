class CreateWelcomeCallResults < ActiveRecord::Migration[5.1]
  def change
    create_table :welcome_call_results do |t|
      t.boolean :active, default: true
      t.string :description

      t.timestamps
    end
  end
end
