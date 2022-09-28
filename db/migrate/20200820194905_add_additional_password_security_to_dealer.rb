class AddAdditionalPasswordSecurityToDealer < ActiveRecord::Migration[5.1]
  def change
    change_table :dealers do |t|
      t.datetime :password_changed_at
    end

    add_index :dealers, :password_changed_at
    
    Dealer.reset_column_information
    Dealer.update_all(password_changed_at: 1.minute.ago)
  end
end
