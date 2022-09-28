# == Schema Information
#
# Table name: lease_document_requests
#
#  id                      :integer          not null, primary key
#  lease_application_id    :integer
#  asset_make              :string
#  asset_model             :string
#  asset_year              :integer
#  asset_vin               :string
#  asset_color             :string
#  exact_odometer_mileage  :string
#  trade_in_make           :string
#  trade_in_model          :string
#  trade_in_year           :string
#  delivery_date           :date
#  gap_contract_term       :integer          default(0)
#  service_contract_term   :integer          default(0)
#  ppm_contract_term       :integer          default(0)
#  tire_contract_term      :integer          default(0)
#  equipped_with           :string
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  manual_vin_verification :boolean
#
# Indexes
#
#  index_lease_document_requests_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

require 'rails_helper'

RSpec.describe LeaseDocumentRequest, type: :model do

  make = Make.create(name: 'Harley-Davidson', lms_manf: "HARLEY-DAV", vin_starts_with: "1HD")

  model_group = ModelGroup.create(
    :name => "Touring",
    :make_id => make.id,
    :minimum_dealer_participation_cents => 20000,
    :residual_reduction_percentage => 90.0,
    :maximum_term_length => 60,
    :backend_advance_minimum_cents => 100000,
    :maximum_haircut_0 => 1.0,
    :maximum_haircut_1 => 1.0,
    :maximum_haircut_2 => 1.0,
    :maximum_haircut_3 => 1.0,
    :maximum_haircut_4 => 1.0,
    :maximum_haircut_5 => 1.0,
    :maximum_haircut_6 => 1.0,
    :maximum_haircut_7 => 1.0,
    :maximum_haircut_8 => 1.0,
    :maximum_haircut_9 => 1.0,
    :maximum_haircut_10 => 1.0,
    :maximum_haircut_11 => 0.95,
    :maximum_haircut_12 => 0.95,
    :maximum_haircut_13 => 0.95,
    :maximum_haircut_14 => 0.95,
    :sort_index => 6
  )


  model_year = ModelYear.create(
    original_msrp_cents: 1899900,
    nada_avg_retail_cents: 1018000,
    nada_rough_cents: 687000,
    name: "Chief Classic",
    year: 2014,
    residual_24_cents: 158543,
    residual_36_cents: 147973,
    residual_48_cents: 137404,
    model_group_id: model_group.id,
    residual_60_cents: 126834,
    maximum_haircut_0: 0.1e1,
    maximum_haircut_1: 0.1e1,
    maximum_haircut_2: 0.1e1,
    maximum_haircut_3: 0.1e1,
    maximum_haircut_4: 0.1e1,
    maximum_haircut_5: 0.1e1,
    maximum_haircut_6: 0.1e1,
    maximum_haircut_7: 0.1e1,
    maximum_haircut_8: 0.1e1,
    maximum_haircut_9: 0.1e1,
    maximum_haircut_10: 0.1e1,
    maximum_haircut_11: 0.1e1,
    maximum_haircut_12: 0.1e1,
    maximum_haircut_13: 0.1e1,
    maximum_haircut_14: 0.1e1,
    start_date: Date.today - 30.days,
    end_date: "2999-12-31".to_date,
    nada_model_number: "4016171",
    police_bike: false,
    nada_volume_number: "155",
    slc_model_group_mapping_flag: true,
    nada_model_group_name: "Cruisers"
    )


    let(:lease_document_request) { create(:lease_document_request, 
      asset_model: 'Chief Classic', 
      asset_year: 2014, 
      asset_make: 'Harley-Davidson', 
      asset_vin: "1HD1JRV64CB052337", 
      exact_odometer_mileage: "100", 
      delivery_date: Date.today,
      asset_color: 'black'
      ) }
  describe '#validate' do

    it { expect(make).to be_valid }
    it { expect(model_year).to be_valid }
    it { expect(lease_document_request).to be_valid }
    it { expect(lease_document_request.model_year_id).not_to be_nil }
    
  end
end
