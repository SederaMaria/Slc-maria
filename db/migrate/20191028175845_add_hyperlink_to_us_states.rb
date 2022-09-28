class AddHyperlinkToUsStates < ActiveRecord::Migration[5.1]
  def change
  	add_column :us_states, :label_text, :string
	add_column :us_states, :hyperlink, :string
	add_column :us_states, :state_enum, :integer
	add_index :us_states, :abbreviation, unique: true
  end
end
