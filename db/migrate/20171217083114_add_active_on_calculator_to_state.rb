class AddActiveOnCalculatorToState < ActiveRecord::Migration[5.1]
  def change
    add_column :states, :active_on_calculator, :boolean, default: false
  end
end
