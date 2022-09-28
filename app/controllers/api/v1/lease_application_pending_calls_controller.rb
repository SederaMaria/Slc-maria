class Api::V1::LeaseApplicationPendingCallsController < Api::V1::ApiController
  before_action :set_lease_application_welcome_call, only: :show

  ROLES_INCLUDED = ["Administrator", "Executive", "Sales Manager", "Servicing Manager", "Verification Manager", "Underwriting User" ]
  COMPLETED_STATUS = 'Complete'

  def index
    authorize(current_user, 'WelcomeCall', 'get')
    @pending_welcome_calls = []
    completed_call_status =  WelcomeCallStatus.where(description: COMPLETED_STATUS).first

    user_security_roles = current_user&.security_roles
    
    if user_security_roles.any?{|role| ROLES_INCLUDED.include?(role['description'])}
      all_welcome_calls = LeaseApplicationWelcomeCall.includes(lease_application: [lessee: :home_address]).group_by(&:lease_application_id)
    else
      all_welcome_calls = LeaseApplicationWelcomeCall.includes(lease_application: [lessee: :home_address]).where("admin_id = ?", current_user.id).group_by(&:lease_application_id)
    end
    all_welcome_calls.each do |lease_application_id, records|
      record = records.sort!{|a,b| b.created_at <=> a.created_at }.first
      records_count = records.reject{|x| x.welcome_call_result_id.nil?}.size
      if record.welcome_call_status_id != completed_call_status.id
        @pending_welcome_calls << OpenStruct.new(record.attributes.merge("pending_welcome_calls_count" =>  records_count))
      end
    end
  end

  def show
    render json: serializer.new(@lease_application_welcome_call).as_json
  end

  private

  def permitted_params
    params.permit(:id)
  end

  def set_lease_application_welcome_call
    @lease_application_welcome_call = LeaseApplicationWelcomeCall.find_by(id: permitted_params[:id])
    render json: {message: "LeaseApplicationWelcomeCall not found."}, status: :not_found unless @lease_application_welcome_call.present?
  end

  def serializer
    WelcomeCalls::LeaseApplicationWelcomeCallSerializer
  end
  
end