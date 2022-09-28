class AddUserTypeToAudits < ActiveRecord::Migration[5.0]
  def change
    add_column :audits, :user_type, :string
  end
end
