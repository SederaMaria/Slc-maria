class Api::V1::WorkflowSettingValuesController < Api::V1::ApiController
    include UnderscoreizeParams

    def index

      begin
        # Dealerships
        workflow_setting_id = WorkflowSetting.sales.id
        dealership_underwriting_id = WorkflowSetting.dealership_underwriting.id
        notify_dealership_underwriting_id = WorkflowSetting.notify_dealership_underwriting.id
        dealership_credit_committee_id = WorkflowSetting.dealership_credit_committee.id
        notify_dealership_credit_committee_id = WorkflowSetting.notify_dealership_credit_committee.id
        
        # Lease Applications
        underwriting_id = WorkflowSetting.underwriting.id
        notify_underwriting_id = WorkflowSetting.notify_underwriting.id

        # Dealerships
        sales = WorkflowSettingValue.where(workflow_setting_id: workflow_setting_id).order(id: :asc)
        dealership_underwriting = WorkflowSettingValue.where(workflow_setting_id: dealership_underwriting_id).order(id: :asc)
        notify_dealership_underwriting = WorkflowSettingValue.where(workflow_setting_id: notify_dealership_underwriting_id).order(id: :asc).present? ? '1' : '0'
        dealership_credit_committee = WorkflowSettingValue.where(workflow_setting_id: dealership_credit_committee_id).order(id: :asc)
        notify_dealership_credit_committee = WorkflowSettingValue.where(workflow_setting_id: notify_dealership_credit_committee_id).order(id: :asc).present? ? '1' : '0'
        
        # Lease Applications
        underwriting = WorkflowSettingValue.where(workflow_setting_id: underwriting_id).order(id: :asc)
        notify_underwriting = WorkflowSettingValue.where(workflow_setting_id: notify_underwriting_id).order(id: :asc).present? ? '1' : '0'


        workflow_setting_values = {
          salesDefaults: get_admin_string_id(sales),
          notifyDealershipUnderwriting: notify_dealership_underwriting,
          dealershipUnderwritingDefaults: get_admin_string_id(dealership_underwriting),          
          notifyCreditCommittee: notify_dealership_credit_committee,
          creditCommitteeDefaults: get_admin_string_id(dealership_credit_committee),
          underwritingDefaults: get_admin_string_id(underwriting),
          notifyUnderwriting: notify_underwriting,
        }

        render json: workflow_setting_values.as_json

      rescue => exception
        Rails.logger.info(exception)
        render json: {message: "Error fetching Workflow Settings Value"}, status: :internal_server_error
      end

    end
    

    def create
      begin
        case workflow_setting          
        when :sales
          workflow_setting_id = WorkflowSetting.sales.id
          process_create(workflow_setting_value_params["admin_user_id"], workflow_setting_id)

        when :dealership_underwriting          
          workflow_setting_id = WorkflowSetting.dealership_underwriting.id
          process_create(workflow_setting_value_params["admin_user_id"], workflow_setting_id)

        when :notify_dealership_underwriting
          notify_dealership_underwriting_id = WorkflowSetting.notify_dealership_underwriting.id
          not_notify_dealership_underwriting_id = WorkflowSetting.not_notify_dealership_underwriting.id
          delete_setting_values(notify_dealership_underwriting_id)
          delete_setting_values(not_notify_dealership_underwriting_id)
          process_create_notify(notify_dealership_underwriting_id)

        when :not_notify_dealership_underwriting
          notify_dealership_underwriting_id = WorkflowSetting.notify_dealership_underwriting.id
          not_notify_dealership_underwriting_id = WorkflowSetting.not_notify_dealership_underwriting.id
          delete_setting_values(notify_dealership_underwriting_id)
          process_create_notify(not_notify_dealership_underwriting_id)

        when :dealership_credit_committee
          workflow_setting_id = WorkflowSetting.dealership_credit_committee.id
          process_create(workflow_setting_value_params["admin_user_id"], workflow_setting_id)

        when :notify_dealership_credit_committee
          notify_dealership_credit_committee_id = WorkflowSetting.notify_dealership_credit_committee.id
          not_notify_dealership_credit_committee_id = WorkflowSetting.not_notify_dealership_credit_committee.id
          delete_setting_values(notify_dealership_credit_committee_id)
          delete_setting_values(not_notify_dealership_credit_committee_id)
          process_create_notify(notify_dealership_credit_committee_id)

        when :not_notify_dealership_credit_committee
          notify_dealership_credit_committee_id = WorkflowSetting.notify_dealership_credit_committee.id
          not_notify_dealership_credit_committee_id = WorkflowSetting.not_notify_dealership_credit_committee.id
          delete_setting_values(notify_dealership_credit_committee_id)
          delete_setting_values(not_notify_dealership_credit_committee_id)
          process_create_notify(not_notify_dealership_credit_committee_id)


        when :underwriting
          workflow_setting_id = WorkflowSetting.underwriting.id
          process_create(workflow_setting_value_params["admin_user_id"], workflow_setting_id)
          
        when :notify_underwriting
          notify_underwriting_id = WorkflowSetting.notify_underwriting.id
          not_notify_underwriting_id = WorkflowSetting.not_notify_underwriting.id
          delete_setting_values(notify_underwriting_id)
          delete_setting_values(not_notify_underwriting_id)
          process_create_notify(notify_underwriting_id)

        when :not_notify_underwriting
          notify_underwriting_id = WorkflowSetting.notify_underwriting.id
          not_notify_underwriting_id = WorkflowSetting.not_notify_underwriting.id
          delete_setting_values(notify_underwriting_id)
          delete_setting_values(not_notify_underwriting_id)
          process_create_notify(not_notify_underwriting_id)

        end

        render json: {message: "Workflow Setting Value created sucessfully" }

      rescue => exception
        Rails.logger.info(exception)
        render json: {message: "Error Creating Workflow Setting Value"}, status: :internal_server_error
      end
    end


    private

    
    def workflow_setting
      settings = { 
        "sales" => :sales,
        "dealership_underwriting" => :dealership_underwriting,
        "notify_dealership_underwriting" => :notify_dealership_underwriting,
        "not_notify_dealership_underwriting" => :not_notify_dealership_underwriting,
        "dealership_credit_committee" => :dealership_credit_committee,
        "notify_dealership_credit_committee" => :notify_dealership_credit_committee,
        "not_notify_dealership_credit_committee" => :not_notify_dealership_credit_committee,
        "underwriting" => :underwriting,
        "notify_underwriting" => :notify_underwriting,
        "not_notify_underwriting" => :not_notify_underwriting,
      }
      settings[params["settings"]]
    end

    def workflow_setting_value_params
      params.permit(:settings, admin_user_id: [])
    end

    def process_create(workflow_setting_param, workflow_setting_id)
      delete_setting_values(workflow_setting_id)
      create_each(workflow_setting_param, workflow_setting_id)
    end

    def process_create_notify(workflow_setting_id)
      create_value(nil, workflow_setting_id)
    end


    def create_each(values, workflow_setting_id)
      values.each do |admin_id|
        create_value(admin_id, workflow_setting_id)
      end
    end

    def create_value(admin_id, workflow_setting_id)
      WorkflowSettingValue.create(admin_user_id: admin_id, workflow_setting_id: workflow_setting_id)
    end

    def delete_setting_values(settings_id)
      WorkflowSettingValue.where(workflow_setting_id: settings_id).delete_all
    end


    def get_admin_string_id(workflow_setting_value)
      workflow_setting_value.map{ |value| value&.admin_user_id.to_s }
    end


    # def serialize(workflow_setting_value)
    #   ActiveModelSerializers::SerializableResource.new(workflow_setting_value, adapter: :json, root: false, key_transform: :camel_lower).as_json
    # end

  end
  