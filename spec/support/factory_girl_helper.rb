RSpec.shared_context "create resources from controller name" do
  def create_resource_from_controller_name(str)
    case str
    when 'application_setting'
      allow(ApplicationSetting).to receive(:instance).and_call_original
      ApplicationSetting.instance.save #create it
      ApplicationSetting.instance #return it
    when 'comment'
      FactoryBot.create(:active_admin_comment)
    when 'dashboard'
      #no-op
    else
      FactoryBot.create(str.to_sym) # if FactoryBot.factories.registered?(str.to_sym)
    end
  end

  def params_for_create(param_key, resource)
    hsh = {
      param_key => attributes_for(param_key.to_sym)
    }
    
    hsh[param_key].merge!(make_id: create(:make).id) if resource.is_a?(ModelGroup)
    hsh[param_key].merge!(dealership_id: create(:dealership).id) if resource.is_a?(Dealer)
    hsh[param_key].delete(:dealership) if resource.is_a?(DealerRepresentative)

    hsh
  end

  def params_for_update(param_key, resource)
    hsh = {
      :id => resource.id, 
      param_key => attributes_for(param_key.to_sym)
    }
    hsh[param_key].delete(:dealership) if resource.is_a?(DealerRepresentative)
    hsh
  end
end