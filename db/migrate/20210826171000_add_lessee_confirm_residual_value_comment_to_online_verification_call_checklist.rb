class AddLesseeConfirmResidualValueCommentToOnlineVerificationCallChecklist < ActiveRecord::Migration[6.0]
  def change
    add_column :online_verification_call_checklists, :lessee_confirm_residual_value_comment, :string    
  end
end
