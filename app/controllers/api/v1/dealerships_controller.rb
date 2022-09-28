class Api::V1::DealershipsController < Api::V1::ApiController
    skip_before_action :verify_authenticity_token
    include UnderscoreizeParams

    before_action :set_dealership, except: [:index, :create, :dealerships_options]

    def dealerships_options
        options = Dealership.all.map{|x| {value: x.id, label: x.name}}
        render json: { dealerships_options: options } 
    end


    def index
      authorize(current_user, 'Dealership', 'get')
      @q = Dealership.ransack(params[:query].try(:merge, m: 'or'))
      dealership = @q.result(distinct: true).includes(:dealer_representatives, :address, :city).order(id: :asc)
      render json: ActiveModelSerializers::SerializableResource.new(dealership, adapter: :json, root: "dealership", key_transform: :camel_lower).as_json
    end

    def show
        render json: ActiveModelSerializers::SerializableResource.new(@dealership, adapter: :json, root: "dealership", key_transform: :camel_lower).as_json
    end


    def approval
        authorize(current_user, 'Dealership', 'update')
        begin
            approval_type = params[:approval_type]
            approval = params[:approval]
            comments = params[:comments]
            dealership_approval = @dealership.dealership_approval(approval_type)
            
            if dealership_approval.nil?
                dealership_approval = @dealership.dealership_approvals.create(dealership_approval_type_id: approval_type_table(approval_type).id)
            end

            if approval_type == 'Sales'
              authorize(current_user, 'DealershipSalesRecommendation', 'update')
            end

            if approval_type == 'Underwriting'
              authorize(current_user, 'DealershipUnderwritingApproval', 'update')
            end

            if approval_type == 'Credit Committee'
              authorize(current_user, 'DealershipCreditCommitteeApproval', 'update')
            end

            dealership_approval.dealership_approval_events.create(admin_user_id: current_user.id, approved: approval, comments: comments)

            if approval_type == 'Sales' && approval == 'true'
                underwriting_approvers = WorkflowSettingValue.where(workflow_setting_id: WorkflowSetting.dealership_underwriting.id).map{ |setting| setting.admin_user.email }
                DealershipMailer.notify_approvers(recipient: underwriting_approvers, dealership: @dealership).deliver_now
            end

            if approval_type == 'Underwriting' && approval == 'true'
                credit_committee_approvers = WorkflowSettingValue.where(workflow_setting_id: WorkflowSetting.dealership_credit_committee.id).map{ |setting| setting.admin_user.email }
                DealershipMailer.notify_approvers(recipient: credit_committee_approvers, dealership: @dealership).deliver_now
            end

            render json: { message: "Successfully Updated" }
        rescue => exception
          Rails.logger.info(exception)
          render json: {message: "Error updating "}, status: :internal_server_error
        end

    end


    def update
        authorize(current_user, 'Dealership', 'update')
        if @dealership.update(dealership_params)
            if params[:dealer_representative_ids]
              @dealership.dealer_representative_ids = params[:dealer_representative_ids].map{ |x| x.to_i }
            end
            
            @dealership.save
            render json: {message: "Dealership updated sucessfully"}
        else
          render json: {message: @dealership.errors.full_messages}, status: 500
        end
    end

    
    def upload_attachments
        authorize(current_user, 'Dealership', 'update')
        begin
            @dealership.dealership_attachments.create(upload_params.merge!({ admin_user_id: current_user.id }))
            render json: {message: "Successfully Uploaded"}
        rescue => exception
            Rails.logger.info(exception.message)
            render json: {message: "Error Uploading"}, status: :internal_server_error 
        end
    end


    def generate_dealer_agreement
        authorize(current_user, 'Dealership', 'update')
        begin
            @attachment = @dealership.dealership_attachments.create(admin_user_id: current_user.id)
            @attachment.upload = File.open(@dealership.prefilled_dealer_agreement)
            @attachment.save!
        rescue => exception
            @attachment.delete
            Rails.logger.info(exception.message)
            render json: {message: "Error Generating Dealer Attachments"}, status: :internal_server_error
        end
    end

  def create
    authorize(current_user, 'Dealership', 'create')
    dealership = Dealership.new(dealership_params)
    dealership.dealer_representative_ids = params[:dealer_representative_ids].map(&:to_i)

    if dealership.respond_to?(:state)
      dealership.state = UsState.find(dealership.address.state).abbreviation
    end

    if dealership.save
      render json: { id: dealership.id }
    else
      render json: { message: dealership.errors.full_messages }, status: 500
    end
  end

    private

    def set_dealership
        @dealership = Dealership.find(params[:id])
    end

    def approval_type_table(description)
        DealershipApprovalType.find_by(description: description)
    end

    def dealership_params
        params.permit(
            :name, :website, :primary_contact_phone, :state, :franchised, :franchised_new_makes, :legal_corporate_entity,
            :dealer_group, :dealer_group, :active, :agreement_signed_on, :executed_by_name, :executed_by_title, :executed_by_slc_on,
            :los_access_date, :notes, :use_experian, :use_equifax, :use_transunion, :access_id, :bank_name, :account_number, :routing_number,
            :account_type, :security_deposit, :enable_security_deposit, :can_submit, :can_see_banner, :deal_fee, :year_incorporated_or_control_year,
            :years_in_business, :previously_approved_dealership, :previous_transactions_submitted, :previous_transactions_closed, 
            :previous_default_rate, :remit_to_dealer_calculation_id, :employer_identification_number, :secretary_state_valid, :business_description,
            :owner_first_name, :owner_last_name, :notification_email, :dealer_license_number, :license_expiration_date,
            :pct_ownership,
            address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :county, :city_id],
            owner_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :county, :city_id]
        )
    end


    def upload_params
        params.permit(:upload)
    end

  end
  