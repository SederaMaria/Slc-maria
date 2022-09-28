class AddReferenceToUsState < ActiveRecord::Migration[6.0]
  def change
    add_column :us_states, :secretary_of_state_website, :string
    add_reference :us_states, :tax_jurisdiction_type
  end
end
