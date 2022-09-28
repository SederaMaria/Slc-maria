class AddNameToEmailTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :email_templates, :name, :string, unique: true
  end
end
