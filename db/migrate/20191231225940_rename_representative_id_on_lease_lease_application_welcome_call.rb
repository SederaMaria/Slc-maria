class RenameRepresentativeIdOnLeaseLeaseApplicationWelcomeCall < ActiveRecord::Migration[5.1]
  def change
    rename_column :lease_application_welcome_calls, :representative_id, :admin_id
  end
end
