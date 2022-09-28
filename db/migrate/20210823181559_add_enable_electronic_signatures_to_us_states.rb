class AddEnableElectronicSignaturesToUsStates < ActiveRecord::Migration[6.0]
  def change
    add_column :us_states, :enable_electronic_signatures, :boolean, default: false, null: false
  end
end
