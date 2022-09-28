class RenameLesseeAvailableToSpeakString < ActiveRecord::Migration[6.0]
  def change
    rename_column :online_verification_call_checklists, :lessee_available_to_speak_string, :lessee_available_to_speak_comment
  end
end
