ActiveAdmin.register LeaseApplicationBlackboxRequest, namespace: :admins do
  menu parent: 'Administration', if: proc{ current_admin_user.is_administrator? }

  member_action(:employment_information, method: [:get]) do
    @datax = resource
    @employment_information = JSON.parse(@datax.leadrouter_response.to_json).dig("extraAttributes", "twn_raw_report", "DataxResponse", "TWNSelectSegment")
    if @employment_information
      parsed_employment_data = @employment_information.dig("EmploymentHistory","Employment")
      @employment_histories = parsed_employment_data.class.to_s == "Array" ? parsed_employment_data : [parsed_employment_data]
    end
    render 'employment_information'
  end

end
