class AddIsDisabledToDealer < ActiveRecord::Migration[5.1]
  def change
    add_column :dealers, :is_disabled, :boolean, default: false, null: false
  end
end
