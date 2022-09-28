if @pending_welcome_calls.present?
  json.pendingWelcomeCalls @pending_welcome_calls do |call|
   lease_application = LeaseApplication.find(call.lease_application_id)
   next unless ["funding_approved", "funded"].include?(lease_application.document_status) || lease_application.nil?
   admin_user = AdminUser.find_by(id: call.admin_id)
   admin_user_name = admin_user.nil? ? " " : lease_application&.lease_application_welcome_calls&.map{ |rep| "#{rep&.admin_user&.first_name} #{rep&.admin_user&.last_name}" }&.uniq&.join(', ')
   result_description = WelcomeCallResult.find_by(id: call.welcome_call_result_id)&.description
   json.dueDate lease_application.welcome_call_due_date_utc
   json.leaseNumber lease_application.application_identifier
   json.id lease_application.id
   json.firstName  lease_application.lessee&.first_name.to_s
   json.lastName  lease_application.lessee&.last_name.to_s
   json.state UsState.where(abbreviation: lease_application.lessee.home_address.state).first&.name&.titleize
   json.dealership lease_application.dealership&.name.to_s
   json.fundingApprovedOn lease_application.funding_approved_on
   json.fundedOn lease_application.funded_on
   json.firstPaymentDate lease_application.first_payment_date
   json.representativeAssigned admin_user_name
   json.pendingWelcomeCallsCount call.pending_welcome_calls_count
   json.lastDispositionResult result_description
  end
else
  json.message 'No Data'
  json.pendingWelcomeCalls([])
end