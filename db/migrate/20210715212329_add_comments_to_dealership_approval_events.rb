class AddCommentsToDealershipApprovalEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :dealership_approval_events, :comments, :string
  end
end
