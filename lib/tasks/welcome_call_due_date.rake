namespace :welcome_call_due_date_los_38 do
  desc 'Patch new single source of truth column with the most recent `lease_application_welcome_calls.due_date` '
  task seed: :environment do
    unless welcome_call_lease_applications.empty?
      welcome_call_lease_applications.each do |app|
        recent_welcome_call = app&.lease_application_welcome_calls&.order("created_at DESC")&.last
        if app.welcome_call_due_date.nil?
          app.update_column(:welcome_call_due_date, (recent_welcome_call.due_date.nil? ? app.calculate_welcome_call_due_date : recent_welcome_call.due_date) )  
        end
      end
    end
  end
  
  def welcome_call_lease_applications
    LeaseApplication.where(id: LeaseApplicationWelcomeCall.all.pluck(:lease_application_id).uniq).limit(nil)
  end
  
end
