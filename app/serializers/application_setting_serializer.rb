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

class ApplicationSettingSerializer < ApplicationSerializer
  attributes :id,  :high_model_year,  :low_model_year,  :acquisition_fee,  
            :dealer_participation_sharing_percentage_24,  :base_servicing_fee,  :dealer_participation_sharing_percentage_36,  
            :dealer_participation_sharing_percentage_48,  :residual_reduction_percentage_24,  :residual_reduction_percentage_36,  
            :residual_reduction_percentage_48,  :residual_reduction_percentage_60,  :dealer_participation_sharing_percentage_60,  
            :global_security_deposit,  :enable_global_security_deposit,  :make_id


  def acquisition_fee
    object.acquisition_fee.to_s
  end

  def base_servicing_fee
    object.base_servicing_fee.to_s
  end

  def dealer_participation_sharing_percentage_24
    object.dealer_participation_sharing_percentage_24.to_money.to_s
  end
  def dealer_participation_sharing_percentage_36  
    object.dealer_participation_sharing_percentage_36.to_money.to_s
  end
  def dealer_participation_sharing_percentage_48 
    object.dealer_participation_sharing_percentage_48.to_money.to_s
  end
  def dealer_participation_sharing_percentage_60
    object.dealer_participation_sharing_percentage_60.to_money.to_s
  end
  def residual_reduction_percentage_24
    object.residual_reduction_percentage_24.to_money.to_s
  end
  def residual_reduction_percentage_36
    object.residual_reduction_percentage_36.to_money.to_s
  end
  def residual_reduction_percentage_48
    object.residual_reduction_percentage_48.to_money.to_s
  end
  def residual_reduction_percentage_60 
    object.residual_reduction_percentage_60.to_money.to_s
  end
  
end
