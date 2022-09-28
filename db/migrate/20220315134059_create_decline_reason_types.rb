class CreateDeclineReasonTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :decline_reason_types do |t|
      t.string :decline_reason_name

      t.timestamps
    end
  end
end
