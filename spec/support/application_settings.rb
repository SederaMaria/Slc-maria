
#object_double for Application Settings Singleton

#  high_model_year                            :integer          default(2017), not null
#  low_model_year                             :integer          default(2007), not null
#  acquisition_fee_cents                      :integer          default(59500), not null
#  dealer_participation_sharing_percentage_24 :decimal(, )      default(50.0), not null
#  base_servicing_fee_cents                   :integer          default(500), not null
#  dealer_participation_sharing_percentage_36 :decimal(, )      default(0.0), not null
#  dealer_participation_sharing_percentage_48 :decimal(, )      default(0.0), not null
#  residual_reduction_percentage_24           :decimal(, )      default(75.0), not null
#  residual_reduction_percentage_36           :decimal(, )      default(70.0), not null
#  residual_reduction_percentage_48           :decimal(, )      default(65.0), not null
#  residual_reduction_percentage_60           :decimal(, )      default(65.0), not null
#  dealer_participation_sharing_percentage_60 :decimal(, )      default(0.0), not null

RSpec.configure do |config|
  config.before(:each) do
    current_year = Date.current.year
    ten_years_ago = current_year - 10

    app_setting_values = {
      high_model_year: current_year,
      low_model_year: ten_years_ago,
      acquisition_fee_cents: 59500,
      base_servicing_fee_cents: 500,
      acquisition_fee: 595.to_money,
      base_servicing_fee: 5.to_money,
      dealer_participation_sharing_percentage_24: 50.0,
      dealer_participation_sharing_percentage_36: 0.0,
      dealer_participation_sharing_percentage_48: 0.0,
      dealer_participation_sharing_percentage_60: 0.0,
      residual_reduction_percentage_24: 75.0,
      residual_reduction_percentage_36: 70.0,
      residual_reduction_percentage_48: 65.0,
      residual_reduction_percentage_60: 65.0,
      model_year_range_descending: current_year.downto(ten_years_ago),
      model_year_range_ascending: (ten_years_ago..current_year),
      display_name: 'Application Settings',
      company_term: nil,
      update_attributes: true,
      local_funding_approval_checklist_path: "#{Rails.root}/spec/data/funding-approval-checklist.pdf",
      funding_approval_checklist: double(url: "#{Rails.root}/spec/data/funding-approval-checklist.pdf"),
      power_of_attorney_template_path: "#{Rails.root}/spec/data/power_of_attorney_template.pdf",
      power_of_attorney_template: double(url: "#{Rails.root}/spec/data/power_of_attorney_template.pdf"),
      illinois_power_of_attorney_template_path: "#{Rails.root}/spec/data/illinois_poa_template.pdf",
      illinois_power_of_attorney_template: double(url: "#{Rails.root}/spec/data/illinois_poa_template.pdf"),
      funding_request_form_path: "#{Rails.root}/spec/data/Funding_Request_Form.pdf",
      funding_request_form: double(url: "#{Rails.root}/spec/data/Funding_Request_Form.pdf"),
      underwriting_hours: '9 to 5 M-F',
    }
    app_setting = double("application_setting", app_setting_values)
    allow(CommonApplicationSetting).to receive(:instance).and_return(app_setting)
    # allow(app_setting).to receive(:read_attribute).with(:dealer_participation_sharing_percentage_60).and_return(0.0)
    # allow(app_setting).to receive(:read_attribute).with(:dealer_participation_sharing_percentage_48).and_return(0.0)
    # allow(app_setting).to receive(:read_attribute).with(:dealer_participation_sharing_percentage_36).and_return(0.0)
    # allow(app_setting).to receive(:read_attribute).with(:dealer_participation_sharing_percentage_24).and_return(50.0)
    # decorated = ApplicationSettingDecorator.decorate(app_setting)
    # allow(app_setting).to receive(:decorate).and_return(decorated)
  end
end
