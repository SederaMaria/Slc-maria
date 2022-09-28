# == Schema Information
#
# Table name: application_settings
#
#  id                                         :integer          not null, primary key
#  high_model_year                            :integer          default(2017), not null
#  low_model_year                             :integer          default(2007), not null
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
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
#  global_security_deposit                    :integer          default(0)
#  enable_global_security_deposit             :boolean          default(FALSE)
#  make_id                                    :integer
#

FactoryBot.define do
  factory :application_setting, class: 'ApplicationSetting' do
    high_model_year { 2017 }
    low_model_year { 2007 }
    global_security_deposit { 1234 }

    factory :application_setting_with_file do
      company_term { fixture_file_upload('spec/data/TPS Report.pdf', Mime[:pdf]) }
    end

    factory :application_setting_with_global_security_deposit do
      enable_global_security_deposit { true }
    end
  end
end
