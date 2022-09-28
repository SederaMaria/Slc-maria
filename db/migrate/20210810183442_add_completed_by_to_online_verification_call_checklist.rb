class AddCompletedByToOnlineVerificationCallChecklist < ActiveRecord::Migration[6.0]
  def change
    add_reference :online_verification_call_checklists, :completed_by
  end
end
