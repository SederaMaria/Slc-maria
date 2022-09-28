class Api::V1::OnlineVerificationCallChecklistsController < Api::V1::ApiController
  include UnderscoreizeParams

  # GET        /api/v1/online-verification-call-checklists/:id
  def show
    lease_application = LeaseApplication.find(params[:id])
    record = lease_application.online_verification_call_checklist || lease_application.build_online_verification_call_checklist
    render json: record, serializer: OnlineVerificationCallChecklistSerializer, key_transform: :camel_lower
  end

  # PATCH      /api/v1/online-verification-call-checklists/:id
  # PUT        /api/v1/online-verification-call-checklists/:id
  def update
    lease_application = LeaseApplication.find(params[:id])
    record = lease_application.online_verification_call_checklist || lease_application.build_online_verification_call_checklist
    record.assign_attributes(online_verification_checklist_params)
    record.completed_by = current_user

    if record.issue
      if record.new_record? || (lease_application.stipulations.verification_call_problem.count < Stipulation.verification_call_problem.count)
        Stipulation.verification_call_problem.each do |stipulation|
          unless lease_application.stipulations.verification_call_problem.where(id: stipulation.id).exists?
            lease_application.lease_application_stipulations.create(stipulation: stipulation)
          end
        end
      end
    end

    if record.save
      render json: record, serializer: OnlineVerificationCallChecklistSerializer, key_transform: :camel_lower
    else
      render json: { message: record.errors.full_messages }, status: :internal_server_error
    end
  end

  # POST       /api/v1/online-verification-call-checklists/:online_verification_call_checklist_id/generate_pdf
  def generate_pdf
    lease_application = LeaseApplication.find(params[:online_verification_call_checklist_id])
    record = lease_application.online_verification_call_checklist

    raise ActiveRecord::RecordNotFound unless record

    # Generate local server file
    record.generate_file!

    # OPTIONAL: Move this entire process in a background job
    # Upload to S3 Bucket
    record.s3_upload!
    # Add to LeaseApplicationAttachment
    record.append_to_lease_application_attachments!
    # Delete local server file
    record.purge_file!
    # OPTIONAL::END

    render json: { message: 'PDF is being saved and will be added to Attachments.', url: record.remote_url }, status: :ok
  end

  private

    def online_verification_checklist_params
      params[:online_verification_call_checklist].permit(
        :lessee_available_to_speak, :lessee_social_security_confirm, :lessee_date_of_birth_confirm,
        :lessee_street_address_confirm, :lessee_email, :lessee_best_phone_number,
        :lessee_can_receive_text_messages, :lease_term_confirm, :monthly_payment_confirm,
        :payment_frequency_confirm, :payment_frequency_type, :first_payment_date_confirm,
        :second_payment_date_confirm, :due_dates_match_lessee_pay_date, :lessee_reported_year,
        :lessee_reported_make, :lessee_reported_model, :lessee_has_test_driven_bike, :notes,
        :vehicle_mileage, :vin_number_last_six, :vehicle_color, :bike_in_working_order,
        :lessee_confirm_residual_value, :lessee_available_to_speak_comment, :lessee_social_security_confirm_comment,
        :lessee_date_of_birth_confirm_comment, :lessee_street_address_confirm_comment, 
        :lessee_can_receive_text_messages_comment, :lease_term_confirm_comment, :monthly_payment_confirm_comment,
        :payment_frequency_confirm_comment, :first_payment_date_confirm_comment, :second_payment_date_confirm_comment,
        :due_dates_match_lessee_pay_date_comment, :lessee_has_test_driven_bike_comment, :bike_in_working_order_comment,
        :issue, :lessee_confirm_residual_value_comment
      )
    end
end
