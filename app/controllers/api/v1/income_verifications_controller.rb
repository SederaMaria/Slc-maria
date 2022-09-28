class Api::V1::IncomeVerificationsController < Api::V1::ApiController
  include UnderscoreizeParams

  before_action :verify_parent_data

  # POST       /api/v1/income-verifications
  def create
    record = @lessee.income_verifications.create(income_verification_params.merge(created_by_admin_id: current_user.id, updated_by_admin_id: current_user.id))
    render json: record, serializer: IncomeVerificationSerializer, key_transform: :camel_lower
  end

  # PATCH      /api/v1/income-verifications/:id
  # PUT        /api/v1/income-verifications/:id
  def update
    record = @lessee.income_verifications.find(params[:id])
    record.assign_attributes(income_verification_params.merge(updated_by_admin_id: current_user.id))
    if record.save
      render json: record, serializer: IncomeVerificationSerializer, key_transform: :camel_lower
    else
      render json: { errors: record.errors.messages }, status: :bad_request
    end
  end

  def destroy
    record = @lessee.income_verifications.find(params[:id])
    record.destroy
    render json: {message: 'Record has been deleted successfully.'}, status: :ok
  end

  private

    def income_verification_params
      params.require(:income_verification).permit(:income_verification_type_id, :income_frequency_id, :employer_client,
                                                  :gross_income_cents, :other_type, :income_type)
    end

    # API consumer is forced to provide valid :lease_application_id and :lessee_id
    def verify_parent_data
      unless lease_application = LeaseApplication.find(params[:lease_application_id])
        return render json: { message: "Lease Application not found." }, status: :not_found
      end

      unless lessee = Lessee.find(params[:lessee_id])
        return render json: { message: "Lessee/CoLessee not found." }, status: :not_found
      end

      # Check if provided Lessee.id belongs to LeaseApplication
      unless lease_application.lessee_id.eql?(lessee.id) || lease_application.colessee_id.eql?(lessee.id)
        return render json: { message: "Data not found." }, status: :not_found
      end

      # Store Lessee for later use
      @lessee = lessee
    end
end
