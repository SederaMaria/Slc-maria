class Api::V1::LeaseApplicationPaymentLimitsController < Api::V1::ApiController
  include UnderscoreizeParams

  # PUT        /api/v1/lease-application-payment-limits/:id
  def update
    record = LeaseApplicationPaymentLimit.find(params[:id])
    record.assign_attributes(permitted_params)

    # Calculate `override_variance`
    # Formula from: `PaymentLimitJob#calculate_payment_limit` (app/jobs/payment_limit_job.rb)
    record.override_variance = record.override_max_allowable_payment - record.total_monthly_payment

    if record.save
      render json: { message: "Update successfull" }
    else
      render json: { message: "#{record.errors.full_messages.to_sentence}" }, status: 500
    end
  end

  # PUT        /api/v1/lease-application-payment-limits/:lease_application_payment_limit_id/reset
  def reset
    record = LeaseApplicationPaymentLimit.find(params[:lease_application_payment_limit_id])

    if record.update(override_max_allowable_payment_cents: nil, override_variance_cents: nil)
      render json: { message: "Reset successfull" }
    else
      render json: { message: "#{record.errors.full_messages.to_sentence}" }, status: 500
    end
  end

  private

  def permitted_params
    params.require(:lease_application_payment_limit).permit(:override_max_allowable_payment)
  end
end
