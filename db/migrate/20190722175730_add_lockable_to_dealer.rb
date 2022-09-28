class AddLockableToDealer < ActiveRecord::Migration[5.1]
  def change
    add_column :dealers, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :dealers, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :dealers, :locked_at, :datetime
    add_index :dealers, :unlock_token, unique: true
  end
end
