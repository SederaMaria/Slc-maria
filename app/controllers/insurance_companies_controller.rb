class InsuranceCompaniesController < InheritedResources::Base

  private

    def insurance_company_params
      params.require(:insurance_company).permit(:company_name, :company_code, :lease_application_id)
    end
end

