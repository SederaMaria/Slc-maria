class Api::V1::DealersLeaseApplicationsController < Api::V1::ApiController
  include UnderscoreizeParams
  before_action :set_application, except: %i[create index applications filter_options]
  before_action :override_current_dealer, only: [:applications]

  def applications
    dealer = Dealer.find(@current_dealer.id)

    if params[:filter].present?
      query = dealer.dealership.lease_applications.order(updated_at: :desc)
      query = query.by_lessee_name(params[:filter][:name]) if params[:filter][:name].present?
      query = query.where(credit_status: params[:filter][:credit_status]) if params[:filter][:credit_status].present?
      if params[:filter][:document_status].present?
        query = query.where(document_status: params[:filter][:document_status])
      end
      if params[:filter][:can_change_bikes].present?
        query = query.can_change_bikes_eq(params[:filter][:can_change_bikes])
      end
      if params[:filter][:archived].present?
        query = query.where(archived: params[:filter][:archived])
      end
      if params[:filter][:time_range].present?
        if params[:filter][:time_range].is_a? Integer
          query = query.with_year(params[:filter][:time_range])
        else
          params_array = params[:filter][:time_range].split(" - ")
          query = query.with_range(params_array[0], params_array[1])
        end
      end
      query = query
    else
      query = dealer.dealership.lease_applications.where(archived: false).order(updated_at: :desc)
    end

    total_sales_price_cents = 0
    funded = query.where(document_status: "funded").includes(:lease_calculator)
    funded.each do |f|
      total_sales_price_cents += f.lease_calculator.total_sales_price_cents
    end

    status_data = {
      submitted: query.where.not(credit_status: "unsubmitted").count,
      approved: query.where(credit_status: "approved").count + query.where(credit_status: "approved_with_contingencies").count,
      no_documents: query.where(document_status: "no_documents").count,
      documents_issued: query.where(document_status: "documents_issued").count,
      documents_requested: query.where(document_status: "documents_requested").count,
      funded: query.where(document_status: "funded").count,
      canceled: query.where(document_status: "canceled").count,
      declinded: query.where(credit_status: "declined").count,
      unsubmitted: query.where(credit_status: "unsubmitted").count,
      total_sales_price: helpers.humanized_money_with_symbol(Money.new(total_sales_price_cents)),
      total: query.count
    }

    # Pagination
    limit = params[:pagination] ? params[:pagination][:page_size].presence || 20 : 20
    page = params[:pagination] ? params[:pagination][:page].presence || 1 : 1
    offset = ((page - 1) * limit)

    lease_applications = ::Api::DealersLeaseApplicationDecorator.decorate_collection(query.limit(limit).offset(offset))
    serialized_lease_applications = lease_applications.empty? ? {} : ActiveModelSerializers::SerializableResource.new(lease_applications,
                                                                                     each_serializer: LeaseApplicationDealerSerializer, adapter: :json, key_transform: :camel_lower, root: false)

    render json: { data: serialized_lease_applications, statusData: status_data, pagination: { total: query.count } }
  end

  def get_details
    if @lease_application
      app = ActiveModelSerializers::SerializableResource.new(@lease_application,
                                                             serializer: LeaseApplicationDealerFormSerializer, adapter: :json, key_transform: :camel_lower, root: false)
      render json: { data: app }
    else
      render json: { message: 'Lease Application not found.' }, status: :not_found
    end
  end

  def submit_to_speedleasing
    current_dealer = Dealer.find(ENV['SYSTEM_DEALER_ID'])
    lease_application_submission = NewDealersLeaseApplicationSubmitterService.new(lease_application: @lease_application,dealer_check: true)
        Rails.logger.info("word = #{@lease_application.id}")
        if lease_application_submission.submit!(event_source: 'api/v1/dealers-lease-applications/submit-to-speedleasing')
          current_dealer.update(current_sign_in_ip: request.remote_ip)
          render json: {message: "Lease Application submitted sucessfully" }
        else
          render json: { message: lease_application_submission.errors.full_messages.join(' ') }, status: 500
          Rails.logger.info("@leaseApplication2 = #{@lease_application}")
        end


  end

  def update_details
    if @lease_application.update(lease_application_params)
      render json: { message: 'Lease Application updated sucessfully' }
    else
      render json: { message: @lease_application.errors.full_messages }, status: 500
    end
  end

  def filter_options
    render json: {
      credit_status: LeaseApplication.aasm(:credit_status).states_for_select,
      document_status: LeaseApplication.aasm(:document_status).states_for_select
    }, key_transform: :camel_lower
  end

  # POST       /api/v1/dealers/applications/:id/archive
  def archive_application
    if @lease_application.update(archived: true)
      render json: { message: 'Lease Application sucessfully moved to Archived' }
    else
      render json: { message: @lease_application.errors.full_messages }, status: 500
    end
  end

  private

  def set_application
    @lease_application = LeaseApplication.find(lease_application_params[:id])
    render json: { message: 'Lease Application not found.' }, status: :not_found unless @lease_application.present?
  end

  def lease_application_params
    params.permit(
      :dealers_lease_application,
      :id, :application_identifier, :document_status, :credit_status, :is_verification_call_completed, :funding_delay_on, :funding_approved_on, :funded_on, :lease_package_received_date, :time_range,
      :payment_bank_name, :payment_aba_routing_number, :payment_account_number, :payment_account_type, :payment_account_holder, :first_payment_date, :payment_first_day, :second_payment_date, :payment_second_day, :payment_frequency,
      :is_dealership_subject_to_clawback, :this_deal_dealership_clawback_amount, :after_this_deal_dealership_clawback_amount, :dealership_commission_clawback_ammount,
      :mail_carrier_id, :application_disclosure_agreement, :vehicle_possession, :welcome_call_due_date,
      lease_calculator_attributes: %i[new_used asset_make asset_year asset_model mileage_tier credit_tier_id],
      lessee_attributes: [:id, :ssn, :email_address, :first_name, :middle_name, :last_name, :suffix, :date_of_birth, :mobile_phone_number, :home_phone_number,
                          :drivers_license_id_number, :at_address_months, :home_ownership, :employer_name, :employer_phone_number, :employment_status, :time_at_employer_months,
                          :time_at_employer_years, :time_at_employer_years, :gross_monthly_income, :proven_monthly_income, :at_address_years, :monthly_mortgage, :job_title, :first_time_rider, :motorcycle_licence,
                          :relationship_to_lessee_id, :is_driving,
                          { home_address_attributes: %i[id street1 street2 city state zipcode county city_id],
                            mailing_address_attributes: %i[id street1 street2 city state zipcode county
                                                           city_id],
                            employment_address_attributes: %i[id city state] }],
      colessee_attributes: [:id, :ssn, :email_address, :first_name, :middle_name, :last_name, :suffix, :date_of_birth, :mobile_phone_number, :home_phone_number,
                            :drivers_license_id_number, :at_address_months, :home_ownership, :employer_name, :employer_phone_number, :employment_status, :time_at_employer_months,
                            :time_at_employer_years, :time_at_employer_years, :gross_monthly_income, :proven_monthly_income, :at_address_years, :monthly_mortgage, :job_title,
                            :relationship_to_lessee_id, :is_driving,
                            { home_address_attributes: %i[id street1 street2 city state zipcode county city_id],
                              mailing_address_attributes: %i[id street1 street2 city state zipcode county
                                                             city_id],
                              employment_address_attributes: %i[id city state] }],
      funding_delays_attributes: %i[id funding_delay_reason_id status notes],
      lease_application_stipulations_attributes: %i[id stipulation_id status notes lease_application_attachment_id],
      lease_application_welcome_calls_attributes: %i[id welcome_call_status_id department welcome_call_type_id welcome_call_result_id lease_application_due_date notes],
      insurance_attributes: %i[company_name property_damage bodily_injury_per_person bodily_injury_per_occurrence comprehensive collision effective_date expiration_date policy_number loss_payee additional_insured],
      references_attributes: %i[id first_name last_name phone_number created_at updated_at city state phone_number_line phone_number_carrier],
      online_funding_approval_checklist_attributes: %i[id no_markups_or_erasure lease_agreement_signed motorcycle_condition_reported credit_application_signed four_references_present valid_dl ach_form_completed insurance_requirements valid_email_address registration_documents_with_slc ods_signed_and_dated proof_of_amounts_due documentation_to_satisfy warranty_products_purchased signed_bos package_reviewed]
    )
  end

  # NOTE: This is a copy from `Api::V1::LeaseApplicationAttachmentsController`
  #       Assuming only Dealer Portal is accessing the affected API endpoint (controller action), this is a desired effect.
  #       In case of conflict, feel free to alter this method but in backwards compatibility with Dealer Portal.
  def override_current_dealer
    # `current_user`: Inherited from Api::V1::ApiController
    if current_user.class.eql?(Dealer)
      @current_dealer = current_user
    else
      return render json: { message: "Actions only allowed to Dealer" }, status: :unauthorized
    end
  end
end