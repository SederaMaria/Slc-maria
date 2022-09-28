class AddHyperlinkAndLabeltextToStates < ActiveRecord::Migration[5.1]
  def change
  	unless column_exists? :states, :label_text
      add_column :states, :label_text, :string
    end
    unless column_exists? :states, :hyperlink
      add_column :states, :hyperlink, :string
    end
  end
end
